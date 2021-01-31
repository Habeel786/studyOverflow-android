import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/models/notesModel.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/myContribution/addNotes.dart';
import 'package:studyoverflow/myContribution/addQuestion.dart';
import 'package:studyoverflow/screens/allQuestions/description.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';
import 'package:studyoverflow/widgets/gradientbutton.dart';
import 'package:studyoverflow/widgets/notesTile.dart';

class MyContributions extends StatefulWidget {

  @override
  _MyContributionsState createState() => _MyContributionsState();
}

class _MyContributionsState extends State<MyContributions> {
  Future<bool> doDelete;
  List temp=['All'];
  List distinctSubjects=[];
  List<Data> mydata = List();
  List<Data> filteredmydata=[];
  List<Data> tempmydata=[];
  String shortText(String text,int maxlength,int limit) {
    if (text.length > maxlength) {
      return text.substring(0, limit) + "....";
    } else {
      return text;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<NotesModel> myNotesData = List();
    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child('test')
          .child(userData.stream)
          .orderByChild('PostedBy')
          .equalTo(user.uid).onValue,
      builder: (_ , AsyncSnapshot<Event> snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Loading();
        }else{
          mydata.clear();
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value ?? {};
          map.forEach((k, v){
            mydata.add(new Data(
                key: k,
                chapter: v['Category'].toString().split('-')[3]??'',
                answer:  v['Answer']??'',
                course:  v['Category'].toString().split('-')[0]??'',
                question: v['Question']??'',
                semester:  v['Category'].toString().split('-')[1]??'',
                subject:  v['Category'].toString().split('-')[2]??'',
                diagram: v['Diagram']??'',
                yearofrepeat:v['YearOfRepeat']??'',
                marks: v['Marks']??'',
                thumbnail: v['Thumbnail']??'',
                postedBy: v['PostedBy']??'',
                postedOn: v['PostedOn']??'',
                dislike: v['DisLike']??0,
                like: v['Like']??0,
                diagramId: v['DiagramID'] ?? ''
            ));
          });
          for(int i=0;i<mydata.length;i++){
            temp.add(mydata[i].subject);
          }
          filteredData(String label){
            setState(() {
              tempmydata=mydata.where((u) => u.subject.contains(label)).toList();
            });
          }
          distinctSubjects=temp.toSet().toList();
          if(tempmydata.isEmpty){
            filteredmydata=mydata;
          }else{
            filteredmydata=tempmydata;
          }
          return StreamBuilder(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child('notesNode')
                  .child(userData.stream)
                  .orderByChild('PostedBy')
                  .equalTo(user.uid
              )
                  .onValue,
              builder: (context, AsyncSnapshot<Event> snapshot) {
                if (snapshot.hasData) {
                  myNotesData.clear();
                  Map<dynamic, dynamic> map = snapshot.data.snapshot.value ??
                      {};
                  map.forEach((k, v) {
                    myNotesData.add(new
                    NotesModel(
                      keys: k,
                      postedBy: v['PostedBy'] ?? '',
                      course: v['Category'].toString().split('-')[0] ?? '',
                      downloads: v['Downloads'] ?? 0,
                      like: v['Like'] ?? 0,
                      notesID: v['NotesID'],
                      notesURL: v['NotesURL'],
                      postedON: v['PostedOn'],
                      semseter: v['Category'].toString().split('-')[1] ?? '',
                      thumbnailID: v['ThumbnailID'],
                      thumbnailURL: v['ThumbnailURL'],
                      title: v['Title'],
                      subject: v['Category'].toString().split('-')[2] ?? '',
                      fileSize: v['Size']??0

                    )
                    );
                  });
                  return Scaffold(
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF2d3447),
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(25.0),
                                    topRight: const Radius.circular(25.0),
                                  ),
                                ),
                                height: 190,
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    GradientButton(
                                      text: 'Upload Questions',
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddQuestion()));
                                      },
                                    ),
                                    GradientButton(
                                      text: 'Upload Notes',
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddNotes()));
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
                        );
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Color(0xffD76EF5),
                    ),
                    body: SafeArea(
                        child: mydata.isEmpty && myNotesData.isEmpty
                            ? nothingToShow(
                            'You can also contribute in the Study Overflow community by adding questions or notes, your name will be displayed along the questions or notes you will upload.',
                            'assets/contribute.png')
                            : Column(
                          children: [
                            Visibility(
                              visible: !myNotesData.isEmpty,
                              child: Container(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.2,
                                  child: ListView.builder(
                                      itemCount: myNotesData.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: NotesTile(
                                            title: myNotesData[index].title,
                                            postedBy: myNotesData[index]
                                                .postedBy,
                                            postedOn: myNotesData[index]
                                                .postedON,
                                            like: myNotesData[index].like,
                                            downloads: myNotesData[index]
                                                .downloads,
                                            thumbnailURL: myNotesData[index]
                                                .thumbnailURL,
                                            course: myNotesData[index].course,
                                            semester: myNotesData[index]
                                                .semseter,
                                            keys: myNotesData[index].keys,
                                            isEdit: true,
                                            notesID: myNotesData[index].notesID,
                                            thumbnailID: myNotesData[index]
                                                .thumbnailID,
                                            notesURL: myNotesData[index]
                                                .notesURL,
                                            subject: myNotesData[index].subject,
                                            fileSize: myNotesData[index].fileSize,
                                          ),
                                        );
                                      }
                                  )
                              ),
                            ),
                            Visibility(
                              visible: !mydata.isEmpty,
                              child: SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: distinctSubjects.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        filteredData(distinctSubjects[index]);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Chip(
                                            avatar: CircleAvatar(
                                              backgroundColor: Color(
                                                  0xffD76EF5),
                                              child: Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                    fontSize: 10.0
                                                ),
                                              ),
                                            ),
                                            label: Text(shortText(
                                                distinctSubjects[index], 7, 10))
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !mydata.isEmpty,
                              child: Expanded(
                                child: ListView.builder(
                                    itemCount: tempmydata.isEmpty ? mydata
                                        .length : filteredmydata.length,
                                    itemBuilder: (_, index) {
                                      return Card(
                                        color: Color(0xFF2d3447),
                                        margin: EdgeInsets.fromLTRB(
                                            10, 6, 10, 0),
                                        child: ListTile(
//                                          onTap: () {
//                                            Navigator.push(context,
//                                                MaterialPageRoute(
//                                                    builder: (context) =>
//                                                        Description(
//                                                          answer: filteredmydata[index]
//                                                              .answer,
//                                                          question: filteredmydata[index]
//                                                              .question,
//                                                          chapter: filteredmydata[index]
//                                                              .chapter,
//                                                          diagram: filteredmydata[index]
//                                                              .diagram,
//                                                          yearofrepeat: filteredmydata[index]
//                                                              .yearofrepeat,
//                                                          marks: filteredmydata[index]
//                                                              .marks,
//                                                          postedBy: filteredmydata[index]
//                                                              .postedBy,
//                                                          postedOn: filteredmydata[index]
//                                                              .postedOn,
//                                                          like: filteredmydata[index]
//                                                              .like,
//                                                          dislike: filteredmydata[index]
//                                                              .dislike,
//                                                          semester: filteredmydata[index]
//                                                              .semester,
//                                                          keys: filteredmydata[index]
//                                                              .key,
//                                                          course: filteredmydata[index]
//                                                              .course,
//                                                        )));
//                                          },
                                          title: Text(
                                            filteredmydata[index].question,
                                            style: TextStyle(
                                                color: Colors.white70),),
                                          subtitle: Text(shortText(
                                              filteredmydata[index].answer
                                                  ?? "", 34, 30),
                                            style: TextStyle(
                                                color: Colors.grey),
                                          ),
                                          leading: Text((index + 1).toString(),
                                            style: TextStyle(
                                                color: Colors.grey),
                                          ),
                                          trailing: SizedBox(
                                            width: 100,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                IconButton(
                                                    icon: Icon(Icons.edit,
                                                      color: Colors.grey,),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  AddQuestion(
                                                                      uanswer: filteredmydata[index]
                                                                          .answer,
                                                                      uquestion: filteredmydata[index]
                                                                          .question,
                                                                      uchapter: filteredmydata[index]
                                                                          .chapter,
                                                                      udiagram: filteredmydata[index]
                                                                          .diagram,
                                                                      uyearOfrepeat: filteredmydata[index]
                                                                          .yearofrepeat,
                                                                      umarks: filteredmydata[index]
                                                                          .marks,
                                                                      usubject: filteredmydata[index]
                                                                          .subject,
                                                                      ukey: filteredmydata[index]
                                                                          .key,
                                                                      udiagramId: mydata[index]
                                                                          .diagramId,
                                                                    usemester: mydata[index].semester,
                                                                  )));
                                                    }),
                                                IconButton(
                                                    icon: Icon(Icons.delete,
                                                      color: Colors.grey,),
                                                    onPressed: () async {
                                                      bool result = await ConfirmationDialogue(context,'Delete','Delete This Question?');
                                                      if (result) {
                                                        await DatabaseServices()
                                                            .deleteQuestionsData(
                                                            mydata[index]
                                                                .diagramId,
                                                            filteredmydata[index]
                                                                .course,
                                                            filteredmydata[index]
                                                                .diagram,
                                                            filteredmydata[index]
                                                                .key);
                                                      }
                                                    }
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  );
                } else {
                  return Loading();
                }
              }
          );
        }
      },
    );
  }
}