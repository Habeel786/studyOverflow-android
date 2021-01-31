import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/models/notesModel.dart';
import 'package:studyoverflow/models/samplepprmodel.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';
import 'package:studyoverflow/widgets/notesTile.dart';
import 'package:studyoverflow/widgets/samplepapertile.dart';

class ShowNotes extends StatefulWidget {
  String stream;
  String semester;
  String subject;
  final String image;

  ShowNotes({this.stream, this.semester, this.subject, this.image});

  @override
  _ShowNotesState createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  var _data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = FirebaseDatabase.instance
        .reference()
        .child('notesNode')
        .child(widget.stream)
        .orderByChild('Category')
        .equalTo(widget.stream + '-' + widget.semester + '-' + widget.subject)
        .onValue;
  }

  @override
  Widget build(BuildContext context) {
    List<NotesModel> mydata = List();
    List<SamplePaperModel> myQuestionData = List();
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          if(globalDownloading){
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
        child: StreamBuilder(
            stream: _data,
            builder: (context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                mydata.clear();
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value ?? {};
                map.forEach((k, v) {
                  mydata.add(new NotesModel(
                      keys: k,
                      postedBy: v['PostedBy'] ?? '',
                      course: v['Category'].toString().split('-')[0] ?? '',
                      downloads: v['Downloads'] ?? 0,
                      like: v['Like'] ?? 0,
                      notesID: v['NotesID'],
                      notesURL: v['NotesURL'],
                      postedON: v['PostedOn'],
                      semseter: v['Category'].toString().split('-')[1] ?? '',
                      thumbnailID: v['ThumbnailID'] ?? null,
                      thumbnailURL: v['ThumbnailURL'] ?? null,
                      title: v['Title'],
                      fileSize: v['Size']
                  ));
                });
                return Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  child: ListView(
                    children: [
                      StreamBuilder(
                          stream:  FirebaseDatabase.instance
                              .reference()
                              .child('samplepdfNode')
                              .child(widget.stream)
                              .orderByChild('Category')
                              .equalTo(widget.stream + '-' + widget.semester + '-' + widget.subject)
                              .onValue,
                          builder: (context, AsyncSnapshot<Event> usnapshot) {
                            if(usnapshot.hasData){
                              myQuestionData.clear();
                              Map<dynamic, dynamic> map = usnapshot.data.snapshot.value ?? {};
                              map.forEach((k, v) {
                                myQuestionData.add(new SamplePaperModel(
                                    keys: k,
                                    course: v['Category'].toString().split('-')[0] ?? '',
                                    notesID: v['NotesID'],
                                    notesURL: v['NotesURL'],
                                    semseter: v['Category'].toString().split('-')[1] ?? '',
                                    title: v['Title'],
                                  fileSize: v['Size']??0,
                                ));
                              });
                              return Visibility(
                                visible: myQuestionData.isNotEmpty,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sample Papers',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white70
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    Container(
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.2,
                                        child:ListView.builder(
                                            itemCount: myQuestionData.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return SamplePaperTile(
                                                title: myQuestionData[index].title,
                                                pdfID: myQuestionData[index].notesID,
                                                downloadURL: myQuestionData[index].notesURL,
                                                fileSize: myQuestionData[index].fileSize,
                                              );
                                            }
                                        )
                                    ),
                                  ],
                                ),
                              );
                            }else{
                              return Center(
                                child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    height: 60,
                                    width: 60,
                                    child: CircularProgressIndicator()
                                ),
                              );
                            }
                          }
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notes',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white70
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            mydata.isNotEmpty?GridView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: mydata.length,
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200.0,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 110 / 150,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return  NotesTile(
                                  title: mydata[index].title,
                                  postedBy: mydata[index].postedBy,
                                  postedOn: mydata[index].postedON,
                                  like: mydata[index].like,
                                  downloads: mydata[index].downloads,
                                  thumbnailURL: mydata[index].thumbnailURL,
                                  course: mydata[index].course,
                                  semester: mydata[index].semseter,
                                  keys: mydata[index].keys,
                                  notesURL: mydata[index].notesURL,
                                  isEdit: false,
                                  notesID: mydata[index].notesID,
                                  fileSize: mydata[index].fileSize,
                                );
                              },
                            ):Center(child: Text('No Data Available')),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Loading();
              }
            }),
      ),
    );
  }
}
