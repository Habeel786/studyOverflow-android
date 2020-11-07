//import 'package:dio/dio.dart';
//import 'dart:io' as io;
//import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:studyoverflow/screens/notes/showpdf.dart';
//
//class SamplePaperTile extends StatefulWidget {
//  final String title;
//  final String pdfID;
//  final String downloadURL;
//  SamplePaperTile({this.title,this.pdfID,this.downloadURL});
//
//  @override
//  _SamplePaperTileState createState() => _SamplePaperTileState();
//}
//
//class _SamplePaperTileState extends State<SamplePaperTile> {
//  double progress=0.0;
//  bool downloading = false;
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//  @override
//  Widget build(BuildContext context) {
//
//    print(downloading);
//    return WillPopScope(
//      onWillPop: () {
//        if(downloading){
//          return showDialog<bool>(
//            context: context,
//            builder: (c) => AlertDialog(
//              backgroundColor: Color(0xFF2d3447),
//              title: Text(
//                'Warning',
//                style: TextStyle(
//                    color: Colors.white
//                ),
//              ),
//              content: Text(
//                "Can't go back, downloading in progress.this happens just once",
//                style: TextStyle(
//                    color: Colors.white70
//                ),
//              ),
//            ),
//          );
//        }else{
//          Navigator.pop(context, true);
//          return null;
//        }
//
//      },
//      child: Padding(
//          padding: const EdgeInsets.symmetric(
//              horizontal: 5.0),
//          child: InkWell(
//            onTap: () async {
//              final status = await Permission.storage.request();
//              if (status.isGranted) {
//                setState(() {
//                  downloading=true;
//                });
//                Dio dio= Dio();
//                try{
//                  var dir= await getExternalStorageDirectory();
//                  String pdfPath="${dir.path}"+"/${widget.pdfID}.pdf";
//                  bool doExists= await io.File(pdfPath).exists();
//                  if(!doExists){
//                    Fluttertoast.showToast(
//                        msg: 'Downloading..', toastLength: Toast.LENGTH_SHORT);
//                    await dio.download(
//                        widget.downloadURL,
//                        '${dir.path}/${widget.pdfID}.pdf',
//                        onReceiveProgress: (rec,total){
//                          setState(() {
//                            progress= rec/total;
//                          });
//                        }
//                    );
//                  }
//                  Navigator.push(context,
//                      MaterialPageRoute(
//                          builder: (context) =>
//                              ShowPDF(
//                                path: pdfPath,
//                                name: widget.title,
//                                pdfid: widget.pdfID,
//                              )));
//                }catch(e){
//                  print(e);
//                }
//              } else {
//                Fluttertoast.showToast(
//                    msg: 'Perission denied', toastLength: Toast.LENGTH_SHORT);
//              }
//            },
//            child: Container(
//              alignment: Alignment.bottomLeft,
//              padding: EdgeInsets.all(8.0),
//              decoration: BoxDecoration(
//                  gradient: LinearGradient(colors: [
//                    Color(0xff4776E6),
//                    Color(0xff8E54E9),
//                  ]),
//                  borderRadius: BorderRadius.circular(15.0)
//              ),
//              width: 120,
//              child: Stack(
//                children: [
//                  Align(
//                    alignment: Alignment.bottomLeft,
//                    child: Text(
//                      widget.title,
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 17.0
//                      ),
//                    ),
//                  ),
//                  Visibility(
//                    visible: downloading,
//                    child: Align(
//                        alignment: Alignment.topLeft,
//                        child: SizedBox(
//                            height: 30.0,
//                            width: 30.0,
//                            child: CircularProgressIndicator(
//                              backgroundColor: Colors.grey,
//                              valueColor:new AlwaysStoppedAnimation<Color>(Colors.red),
//                              value: progress,
//                            ))
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          )
//      ),
//    );
//  }
//}
