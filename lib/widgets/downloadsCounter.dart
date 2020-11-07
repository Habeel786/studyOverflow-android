import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/downloadmodel.dart';
import 'package:studyoverflow/screens/notes/showpdf.dart';
import 'dart:io' as io;
import 'package:studyoverflow/services/database.dart';

class DownloadsCounter extends StatefulWidget {
  final DatabaseReference databaseReference;
  final String keys;
  final int currentCount;
  final String course;
  final String downloadURL;
  final String title;
  final String pdfID;

  DownloadsCounter(
      {this.databaseReference,
      this.keys,
      this.currentCount,
      this.course,
      this.title,
      this.downloadURL,
      this.pdfID});

  @override
  _DownloadsCounterState createState() => _DownloadsCounterState();
}

class _DownloadsCounterState extends State<DownloadsCounter> {
  bool downloading= false;
  double progress;

  increment(int count) {

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DownloadModel(
          downloadURL: widget.downloadURL,
          title: widget.title,
          context: context,
          pdfID: widget.pdfID,
          course: widget.course,
          count: widget.currentCount,
          isDownloadingNotes: true,
          keys: widget.keys
      ),
      child:Consumer<DownloadModel>(
          builder: (context,model,child){
            return  WillPopScope(
              onWillPop: () {
                if(model.isDownloading){
                  return showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      backgroundColor: Color(0xFF2d3447),
                      title: Text(
                        'Warning',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      content: Text(
                        "Can't go back, downloading in progress.this happens just once",
                        style: TextStyle(
                            color: Colors.white70
                        ),
                      ),
                    ),
                  );
                }else{
                  Navigator.pop(context, true);
                  return null;
                }

              },
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      final status = await Permission.storage.request();
                      if (status.isGranted) {
                       model.startDownload();
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Perission denied', toastLength: Toast.LENGTH_SHORT);
                      }
                    },
                    child: model.isDownloading?Container(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor:new AlwaysStoppedAnimation<Color>(Color(0xffD76EF5)),
                          value: model.downloadProgress,
                        )
                    ):Icon(
                      Icons.visibility,
                      color: Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: StreamBuilder(
                        stream: widget.databaseReference
                            .child(widget.course)
                            .child(widget.keys)
                            .child('Downloads')
                            .onValue,
                        builder: (context, AsyncSnapshot<Event> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              widget.currentCount.toString(),
                              style: TextStyle(color: Colors.black54),
                            );
                          } else {
                            int count = snapshot.data.snapshot.value;
                            return Text(
                              count.toString(),
                              style: TextStyle(color: Colors.black54),
                            );
                          }
                        }),
                  )
                ],
              ),
            );
          }
      )
    );
  }
}
