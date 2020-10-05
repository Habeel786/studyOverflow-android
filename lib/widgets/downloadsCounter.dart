import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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
  increment(int count) {
    DatabaseServices().updateDownloads(
        count + 1, widget.keys, widget.course, widget.databaseReference);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final status = await Permission.storage.request();
            Fluttertoast.showToast(
                msg: 'Downloading...', toastLength: Toast.LENGTH_SHORT);

            if (status.isGranted) {
              final externalDir = await getExternalStorageDirectory();
              await FlutterDownloader.enqueue(
                url: widget.downloadURL,
                savedDir: externalDir.path,
                fileName: widget.title,
                showNotification: true,
                // show download progress in status bar (for Android)
                openFileFromNotification:
                    true, // click on notification to open downloaded file (for Android)
              );
            } else {
              print('permission denied');
            }

            increment(widget.currentCount);
          },
          child: Icon(
            Icons.file_download,
            color: Colors.grey,
          ),
        ),
        StreamBuilder(
            stream: widget.databaseReference
                .child(widget.course)
                .child(widget.keys)
                .child('Downloads')
                .onValue,
            builder: (context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                  widget.currentCount.toString(),
                  style: TextStyle(color: Colors.blue),
                );
              } else {
                int count = snapshot.data.snapshot.value;
                return Text(
                  count.toString(),
                  style: TextStyle(color: Colors.blue),
                );
              }
            })
      ],
    );
  }
}
