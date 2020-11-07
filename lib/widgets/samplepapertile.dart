import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/downloadmodel.dart';

class SamplePaperTile extends StatefulWidget {
  final String title;
  final String pdfID;
  final String downloadURL;
  SamplePaperTile({this.title,this.pdfID,this.downloadURL});

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
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 5.0),
          child: Consumer<DownloadModel>(
            builder: (context,model,child){
              return WillPopScope(
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
                child: InkWell(
                  onTap: () async {
                    final status = await Permission.storage.request();
                    if (status.isGranted) {
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
                ),
              );
            },
          )
      ),
    );
  }
}
