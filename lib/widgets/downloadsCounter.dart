//import 'package:dio/dio.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:provider/provider.dart';
//import 'package:studyoverflow/models/downloadmodel.dart';
//import 'package:studyoverflow/screens/notes/showpdf.dart';
//import 'dart:io' as io;
//import 'package:studyoverflow/services/database.dart';
//import 'package:studyoverflow/shared/constants.dart';
//
//class DownloadsCounter extends StatefulWidget {
//  final DatabaseReference databaseReference;
//  final String keys;
//  final int currentCount;
//  final String course;
//  final String downloadURL;
//  final String title;
//  final String pdfID;
//  final int fileSize;
//
//
//  DownloadsCounter(
//      {this.databaseReference,
//      this.keys,
//      this.currentCount,
//      this.course,
//      this.title,
//      this.downloadURL,
//      this.pdfID,
//      this.fileSize
//   });
//
//  @override
//  _DownloadsCounterState createState() => _DownloadsCounterState();
//}
//
//class _DownloadsCounterState extends State<DownloadsCounter> {
//  bool downloading= false;
//  double progress;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//  @override
//  Widget build(BuildContext context) {
//    return ChangeNotifierProvider(
//      create: (context) => DownloadModel(
//          downloadURL: widget.downloadURL,
//          title: widget.title,
//          context: context,
//          pdfID: widget.pdfID,
//          course: widget.course,
//          count: widget.currentCount,
//          isDownloadingNotes: true,
//          keys: widget.keys,
//          fileSize: widget.fileSize
//      ),
//      child:Consumer<DownloadModel>(
//          builder: (context,model,child){
//            return  Column(
//              children: [
//                InkWell(
//                  onTap: () async {
//                    final status = await Permission.storage.request();
//                    if (status.isGranted) {
//                      setState(() {
//                        globalDownloading=true;
//                      });
//                      Fluttertoast.showToast(
//                          msg: "Downloading started, don't change the Tab", toastLength: Toast.LENGTH_SHORT);
//                     model.startDownload();
//                    } else {
//                      Fluttertoast.showToast(
//                          msg: 'Perission denied', toastLength: Toast.LENGTH_SHORT);
//                    }
//                  },
//                  child: model.isDownloading?Container(
//                      height: 25,
//                      width: 25,
//                      child: CircularProgressIndicator(
//                        backgroundColor: Colors.grey,
//                        valueColor:new AlwaysStoppedAnimation<Color>(Colors.red),
//                        value: model.downloadProgress,
//                      )
//                  ):Icon(
//                    Icons.visibility,
//                    color: Colors.black54,
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.only(top:8.0),
//                  child: StreamBuilder(
//                      stream: widget.databaseReference
//                          .child(widget.course)
//                          .child(widget.keys)
//                          .child('Downloads')
//                          .onValue,
//                      builder: (context, AsyncSnapshot<Event> snapshot) {
//                        if (snapshot.connectionState == ConnectionState.waiting) {
//                          return Text(
//                            widget.currentCount.toString(),
//                            style: TextStyle(color: Colors.black54),
//                          );
//                        } else {
//                          int count = snapshot.data.snapshot.value;
//                          return Text(
//                            count.toString(),
//                            style: TextStyle(color: Colors.black54),
//                          );
//                        }
//                      }),
//                )
//              ],
//            );
//          }
//      )
//    );
//  }
//}
