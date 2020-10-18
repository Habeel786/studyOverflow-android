import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:studyoverflow/services/database.dart';

class DownloadsCounter extends StatefulWidget {
  final DatabaseReference databaseReference;
  final String keys;
  final int currentCount;
  final String course;
  final String downloadURL;
  final String title;

  DownloadsCounter(
      {this.databaseReference,
      this.keys,
      this.currentCount,
      this.course,
      this.title,
      this.downloadURL});

  @override
  _DownloadsCounterState createState() => _DownloadsCounterState();
}

class _DownloadsCounterState extends State<DownloadsCounter> {
  bool downloading= false;
  double progress;
  increment(int count) {
    DatabaseServices().updateDownloads(
        count + 1, widget.keys, widget.course, widget.databaseReference);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {

            final status = await Permission.storage.request();
            if (status.isGranted) {
              Dio dio= Dio();
              try{
                var dir= await getExternalStorageDirectory();
                //var dir= await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
                Fluttertoast.showToast(
                    msg: 'Downloading..', toastLength: Toast.LENGTH_SHORT);
                await dio.download(
                    widget.downloadURL,
                   '${dir.path}/${widget.title}.pdf',
                    onReceiveProgress: (rec,total){
                      setState(() {
                        downloading=true;
                        // progressString=((rec/total)*100).toString();
                        progress= rec/total;
                      });
                    }
                );
                Fluttertoast.showToast(
                msg: 'saved in $dir', toastLength: Toast.LENGTH_LONG);
                increment(widget.currentCount);
              }catch(e){
                print(e);
              }
              setState(() {
                downloading=false;
              });
            } else {
              Fluttertoast.showToast(
                  msg: 'Perission denied', toastLength: Toast.LENGTH_SHORT);
            }

          },
          child: downloading?Container(
            height: 25,
              width: 25,
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor:new AlwaysStoppedAnimation<Color>(Colors.redAccent),
                value: progress,
              )
          ):Icon(
            Icons.file_download,
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
    );
  }
}
