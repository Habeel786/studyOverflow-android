import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:studyoverflow/services/admob_service.dart';
class Description extends StatefulWidget {
 final String question;
 final String answer;
 final String chapter;
 final String diagram;
 final String yearofrepeat;
 final String marks;
 final String postedBy;
 final dynamic postedOn;


 Description({this.question, this.answer, this.chapter, this.diagram,this.yearofrepeat,this.marks,this.postedBy,this.postedOn});

 @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  final ams = AdmobService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Admob.initialize('ca-app-pub-9118153038397153~5910414684');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,
        backgroundColor: Color(0xffD76EF5),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 40,left: 20,right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Marks:${widget.marks??""}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.green
                        ),
                      ),
                      Text(widget.yearofrepeat??"",
                        style: TextStyle(
                          fontSize: 15,
                            color: Colors.red
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),

                  Text(widget.question,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey[400]
                  ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: widget.diagram==''?Container():enableUpload(),
                  ),
                  SizedBox(height: 20,),
                  Text(widget.answer,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400]
                    ),
                  ),
                  SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: widget.postedBy!=''&&widget.postedBy!=null?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Posted by: ${widget.postedBy}',style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            color: Colors.grey[400])),
                        Text('on: ${widget.postedOn}',style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            color: Colors.grey[400])),
                      ],
                    ) :Container(),
                  ),
                  SizedBox(height: 20,),
                  //AD_HERE
                  AdmobBanner(
                      adUnitId: "ca-app-pub-9118153038397153/1410457549",
                      adSize: AdmobBannerSize.FULL_BANNER),
                  SizedBox(height: 20,),
                ],
              ),
            ),

        ),
      ),
    );
  }
  Widget enableUpload(){
    return Padding(
      padding: const EdgeInsets.only(top:50,bottom: 30),
      child: Container(
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.diagram,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ],
        ),
      ),
    );
  }
}
