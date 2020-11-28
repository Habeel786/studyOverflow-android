import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:studyoverflow/shared/constants.dart';

class ShowPDF extends StatefulWidget {
  String path;
  String name;
  String pdfid;
  int fileSize;

  ShowPDF({this.path,this.name,this.pdfid,this.fileSize});

  @override
  _ShowPDFState createState() => _ShowPDFState();
}

class _ShowPDFState extends State<ShowPDF> {


  PdfController pdfController;
  int _allPagesCount =0;
  int _actualPageNumber =1;
  bool isSearching=false;
  var banner;

  Widget _currentAd = SizedBox(
    height: 0,
    width: 0,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    FacebookAudienceNetwork.init(
//     // testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6",
//      //optional
//    );
    pdfController = PdfController(
      document: PdfDocument.openFile(widget.path),
    );
//    Admob.initialize('ca-app-pub-9118153038397153~5910414684');
//    banner =  AdmobBanner(
//        adUnitId: "ca-app-pub-9118153038397153/4687179963",
//        adSize: AdmobBannerSize.FULL_BANNER);
  setState(() {
    _currentAd= FacebookBannerAd(
      placementId: "410376460331794_410624736973633",
      bannerSize: BannerSize.STANDARD,
      listener: (result,value){
        print('BannerAd$result-->$value');

      },
    );
  }
  );
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.white,
       appBar: AppBar(
         backgroundColor: Color(0xFF2d3447),
         title: !isSearching ? Text(widget.name) :
         AnimatedContainer(
           duration: Duration(milliseconds: 500),
           decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(30),
               color: Colors.white
           ),
           child: Padding(
             padding: const EdgeInsets.only(left: 20, right: 20),
             child: TextField(
               keyboardType:TextInputType.numberWithOptions(decimal: true) ,
               onChanged: (pageno) {
                 pdfController.animateToPage(int.parse(pageno), duration: Duration(milliseconds: 250), curve: Curves.ease);
               },
               style: TextStyle(
                   color: Colors.black
               ),
               decoration: InputDecoration(
                   border: InputBorder.none,
                   icon: Icon(Icons.search),
                   hintText: "Go To Page..",
                   hintStyle: TextStyle(
                       color: Colors.grey[600]
                   )
               ),
             ),
           ),
         ),
         actions: [
           isSearching ? IconButton(
               icon: Icon(Icons.clear, color: Colors.white,),
               onPressed: () {
                 setState(() {
                   isSearching = false;
                 });
               }) : IconButton(
               icon: Icon(Icons.search, color: Colors.white,),
               onPressed: () {
                 setState(() {
                   isSearching = true;
                 });
               }),
           Padding(
             padding: EdgeInsets.only(right: 10),
             child: Center(
               child: Text(
                   '$_actualPageNumber/$_allPagesCount'
               ),
             ),
           ),
         ],
       ),
      body: Column(
        children: [
          Expanded(
            child:PdfView(
              onDocumentError: (e){
//                File file = File(widget.path);
//                file.delete();
              print(e);
              },
              scrollDirection: Axis.vertical,
              controller: pdfController,
              documentLoader:loaders(),
              pageLoader: loaders(),
              errorBuilder: (exception){
                return Center(child: Text(exception.toString()));
               },
              onDocumentLoaded: (document) {
                setState(() {
                  _allPagesCount = document.pagesCount;
                });
              },
              onPageChanged: (page) {
                setState(() {
                  _actualPageNumber = page;
                });
              },
            )
          ),
//          Flexible(
//            child: Align(
//              alignment: Alignment(0,1),
//              child: _currentAd,
//            ),
//            fit: FlexFit.tight,
//            flex: 2,
//          )
          Align(
            alignment: Alignment.center,
            child: _currentAd,
          ),
        ],
      ),
    );
  }
}

