import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/downloadmodel.dart';
import 'package:studyoverflow/shared/constants.dart';

class SamplePaperTile extends StatefulWidget {
  final String title;
  final String pdfID;
  final String downloadURL;
  final int fileSize;

  SamplePaperTile({this.title,this.pdfID,this.downloadURL,this.fileSize});

  @override
  _SamplePaperTileState createState() => _SamplePaperTileState();
}

class _SamplePaperTileState extends State<SamplePaperTile> {

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
          isDownloadingNotes: false,
        fileSize: widget.fileSize
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 5.0),
          child: Consumer<DownloadModel>(
            builder: (context,model,child){
              return InkWell(
                onTap: () async {
                  final status = await Permission.storage.request();
                  if (status.isGranted) {
                    setState(() {
                      globalDownloading=true;
                    });
                    model.startDownload();
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Perission denied', toastLength: Toast.LENGTH_SHORT);
                  }
                },
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xff4776E6),
                        Color(0xff8E54E9),
                      ]),
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  width: 120,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0
                          ),
                        ),
                      ),
                      Visibility(
                        visible: model.isDownloading,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                                height: 30.0,
                                width: 30.0,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  valueColor:new AlwaysStoppedAnimation<Color>(Colors.red),
                                  value: model.downloadProgress,
                                ))
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
      ),
    );
  }
}
