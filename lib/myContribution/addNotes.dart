import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/models/notificationModel.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/services/imageuploadservice.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/widgets/gradientbutton.dart';
import 'package:uuid/uuid.dart';

class AddNotes extends StatefulWidget {
  final String uStream;
  final String uSemester;
  final String uTitle;
  String uThumbnailURL;
  String uThumbnailID;
  String uNotesURL;
  final String uNotesID;
  final String uSubject;
  final String keys;
  final int uDownloads;
  final int uLikes;
  int fileSize;


  AddNotes(
      {this.uTitle,
      this.uThumbnailURL,
      this.uThumbnailID,
      this.uNotesURL,
      this.uNotesID,
      this.uSubject,
      this.uStream,
      this.uSemester,
      this.keys,
      this.uDownloads,
      this.uLikes,
      this.fileSize
});

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  String title;
  String _currentsubject;
  File thumbnail;
  String pdfName;
  dynamic thumbnailURL;
  dynamic notesURL;
  String thumbnailID;
  String notesID;
  bool showLoading = false;
  bool removeThumbnail = false;
  File pdf;
  Color messageColor = Colors.white70;
  var event;

  final _formkey = GlobalKey<FormState>();

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://testapp-b0eef.appspot.com');
  StorageUploadTask _uploadTask;

  _startUpload(File pdf, String id) async {
    try {
      String filePath = 'notes/$id.pdf';
      setState(() {
        _uploadTask = _storage.ref().child(filePath).putFile(pdf);
        widget.fileSize=null;
      });
      StorageTaskSnapshot storageTaskSnapshot;
      StorageTaskSnapshot snapshot = await _uploadTask.onComplete;
      if (snapshot.error == null) {
        storageTaskSnapshot = snapshot;
        String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        setState(() {
          widget.uNotesURL = null;
          notesURL = downloadUrl;
        });
      }
    } catch (e) {
      setState(() {
        pdfName = 'Please Choose the file first';
        messageColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2d3447),
        centerTitle: true,
        title: Text('Add Notes'),
      ),
      body: WillPopScope(
        onWillPop: () {
          if(_uploadTask!=null){
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
                  "Please wait, uploading notes",
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
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: StreamBuilder(
            stream:DatabaseServices(uid: user.uid).userData,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                UserData userData = snapshot.data;
                return SingleChildScrollView(
                    child:Container(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choose Thumbnail (Optional)',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 25.0),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.43,
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    thumbnail == null &&
                                        widget.uThumbnailURL == null
                                        ? IconButton(
                                      onPressed: () async {
                                        File tempThumbnail =
                                        await UploadImage().getImage(
                                            ImageSource.gallery);
                                        setState(() {
                                          thumbnail = tempThumbnail;
                                          thumbnailID = Uuid().v4();
                                        });
                                      },
                                      icon: Icon(Icons.add_circle_outline),
                                      iconSize: 60.0,
                                      color: Colors.white70,
                                    )
                                        : widget.uThumbnailURL != null
                                        ? Image.network(
                                      widget.uThumbnailURL,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.file(
                                      thumbnail,
                                      fit: BoxFit.cover,
                                    ),
                                    Visibility(
                                      visible: thumbnail != null ||
                                          widget.uThumbnailURL != null,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                removeThumbnail = true;
                                                widget.uThumbnailURL = null;
                                                thumbnail = null;
                                              });
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white70, width: 2.0),
                                  gradient: LinearGradient(colors: [
                                    Color(0xff4776E6),
                                    Color(0xff8E54E9),
                                  ]),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Visibility(
                                visible: thumbnail != null ||
                                    widget.uThumbnailURL != null,
                                child: OutlineButton(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2.0),
                                    child: Text(
                                      'Change Thumbnail',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    onPressed: () async {
                                      File tempThumbnail = await UploadImage()
                                          .getImage(ImageSource.gallery);
                                      setState(() {
                                        thumbnail = tempThumbnail;
                                        thumbnailID = Uuid().v4();
                                        widget.uThumbnailURL = null;
                                      });
                                    }),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                maxLength: 30,
                                initialValue: title ?? widget.uTitle,
                                style: TextStyle(color: Colors.white70),
                                validator: (val) => val.length < 6
                                    ? "There must be 6 characters minimum"
                                    : null,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.grey[600]),
                                  labelText: 'Enter Title',
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    title = val;
                                  });
                                },
                              ),
                              StreamBuilder(
                                  stream: DatabaseServices().getSubjects(widget.uStream??userData.stream),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      SubjectsModel allSubjects= snapshot.data;
                                      List subjects = allSubjects.subjects;
                                      Map tempsub = subjects[int.parse(widget.uSemester??userData.semester)-1];
                                      List names= tempsub.keys.toList();
                                      print(names);
                                      return DropdownButtonFormField(
                                        dropdownColor: Color(0xFF2d3447),
                                        style: TextStyle(color: Colors.white70),
                                        validator: (val) {
                                          return val == null
                                              ? "Subject Empty"
                                              : null;
                                        },
                                        isExpanded: true,
                                        value: _currentsubject ?? widget.uSubject,
                                        items: names.map((subject) {
                                          return DropdownMenuItem(
                                            value: subject,
                                            child: Text("$subject"),
                                          );
                                        }).toList(),
                                        onChanged: (val) =>
                                            setState(() => _currentsubject = val),
                                        decoration: InputDecoration(
                                          labelStyle:
                                          TextStyle(color: Colors.grey[600]),
                                          labelText: 'Select Subject',
                                        ),
                                      );
                                    } else {
                                      return Text('Please wait');
                                    }
                                  }),
                              SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                children: [
                                  OutlineButton(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                      child: Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () async {
                                        FilePickerResult result =
                                        await FilePicker.platform.pickFiles(
                                          allowCompression: true,
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf'],
                                        );
                                        if (result != null) {
                                          File tempfile =
                                          File(result.files.single.path);
                                          PlatformFile file = result.files.first;
                                          setState(() {
                                            messageColor = Colors.white70;
                                            pdfName = file.name;
                                            pdf = tempfile;
                                          });
                                        }
                                        setState(() {
                                          notesID = Uuid().v4();
                                        });
                                      }),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  pdfName == null
                                      ? widget.uTitle == null
                                      ? Text(
                                    'Choose PDF',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 20.0),
                                  )
                                      : Text(
                                    "Choose New PDF,\n Or leave blank to\n continue with existing one",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15.0),
                                  )
                                      : Expanded(
                                    child: Text(
                                      pdfName,
                                      style: TextStyle(
                                          color: messageColor,
                                          fontSize: 15.0),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _uploadTask != null
                                  ?StreamBuilder<StorageTaskEvent>(
                                  stream: _uploadTask.events,
                                  builder: (context, snapshot) {
                                    event = snapshot?.data?.snapshot;
                                    double progressPercent = event != null
                                        ? event.bytesTransferred /
                                        event.totalByteCount
                                        : 0;
                                    return Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                            child: LinearProgressIndicator(
                                              minHeight: 10.0,
                                              value: progressPercent,
                                              backgroundColor: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            '${(progressPercent * 100).toStringAsFixed(2)} % ',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ]);
                                  })
                                  : Center(
                                  child: showLoading
                                      ? CircularProgressIndicator(
                                    strokeWidth: 5.0,
                                  )
                                      : GradientButton(
                                    text: 'Upload Notes',
                                    onTap: () async {
                                      print('widget:${widget.fileSize}');
                                      //print('event:${event.totalByteCount}');
                                      if (_formkey.currentState
                                          .validate()) {
                                        setState(() {
                                          showLoading = true;
                                        });
                                        if (removeThumbnail) {
                                          await DatabaseServices()
                                              .deleteImage(
                                              'notesThumbnail/',
                                              widget.uThumbnailID);
                                          setState(() {
                                            widget.uThumbnailID = null;
                                          });
                                        }
                                        if (thumbnail != null) {
                                          String tempURL =
                                          await UploadImage()
                                              .uploadImage(
                                              widget.uThumbnailID ??
                                                  thumbnailID,
                                              thumbnail,
                                              'notesThumbnail/');
                                          setState(() {
                                            thumbnailURL = tempURL;
                                            showLoading = false;
                                          });
                                        }
                                        setState(() {
                                          showLoading = false;
                                        });
                                        if (pdf != null) {
                                          await _startUpload(
                                              pdf,
                                              widget.uNotesID ??
                                                  notesID);
                                        }
                                        if (widget.uNotesURL != null ||
                                            notesURL != null) {
                                          DatabaseServices(
                                              uid: user.uid)
                                              .addNotes(
                                              title ??
                                                  widget.uTitle,
                                              widget.uNotesURL ??
                                                  notesURL,
                                              widget.uThumbnailURL ??
                                                  thumbnailURL,
                                              _currentsubject ??
                                                  widget.uSubject,
                                              widget.keys ?? '',
                                              widget.uStream ??
                                                  userData.stream,
                                              widget.uSemester ??
                                                 userData.semester,
                                              widget.uThumbnailID ??
                                                  thumbnailID,
                                              widget.uNotesID ??
                                                  notesID,
                                              widget.uDownloads??0,
                                              widget.uLikes??0,
                                              widget.fileSize??event.totalByteCount??0
                                          );
                                          setState(() {
                                            _uploadTask=null;
                                          });
                                          Fluttertoast.showToast(
                                            msg: 'Notes Uploaded',
                                            toastLength:
                                            Toast.LENGTH_SHORT,
                                          );
                                        }
                                      }
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                );
              }else{
                return Loading();
              }
            }
          ),
        ),
      ),
    );
  }
}
