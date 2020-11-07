import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:studyoverflow/screens/notes/showpdf.dart';
import 'package:studyoverflow/services/database.dart';

class DownloadModel extends ChangeNotifier{
  double _progress = 0;
  bool _downloading = false;
  bool isDownloadingNotes=false;
  int count;
  String keys;
  String course;
  String pdfID;
  String downloadURL;
  String title;


  DownloadModel({this.pdfID, this.downloadURL, this.title, this.context,this.isDownloadingNotes,this.count,this.keys,this.course});

  get downloadProgress => _progress;
  get isDownloading=>_downloading;

  BuildContext context;

  void startDownload() async{
    _downloading=true;
    notifyListeners();
    Dio dio= Dio();
    try{
      var dir= await getExternalStorageDirectory();
      String pdfPath="${dir.path}"+"/$pdfID.pdf";
      bool doExists= await io.File(pdfPath).exists();
      if(!doExists) {
        await dio.download(
             downloadURL,
            '${dir.path}/$pdfID.pdf',
            onReceiveProgress: (rec, total) {
                _progress = rec / total;
                notifyListeners();
            }
        );
        if(isDownloadingNotes){
          final DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference().child('notesNode');
          DatabaseServices().updateDownloads(
              count + 1, keys, course, databaseReference);
        }
      }
      _downloading=false;
      notifyListeners();
      print('testing');
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  ShowPDF(
                    path: pdfPath,
                    name:  title,
                    pdfid: pdfID,
                  )));
    }catch(e){
      print(e);
    }
}
}