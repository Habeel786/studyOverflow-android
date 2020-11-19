import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/screens/home/notesandquestions.dart';
import 'package:studyoverflow/screens/notes/showNotes.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'dart:math';
class SubjectList extends StatefulWidget {
  final Map subjects;
  final String semester;
  SubjectList({this.subjects,this.semester});

  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);
    List subjectname = widget.subjects.keys.toList();
    List subjectThumbnail = widget.subjects.values.toList();
    final _random = new Random();
    return Container(
      height: 250,
      width: 150,
      child: Column(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(top: 5.0),
              height: 40.0,
              child: Text(
                  "Semester ${widget.semester}",
                style: TextStyle(
                  fontSize: 20.0
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: widget.subjects.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: LinearGradient(
                          colors: gradientcolors[_random.nextInt(5)]
                        )
                      ),
                      height: 200,
                      width: 150,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                NotesAndQuestions(
                                  subjectname:subjectname[index],
                                  stream: userData.stream,
                                  semester: widget.semester,
                                  imageURL: subjectThumbnail[index],
                                )
//                                ShowNotes(
//                                  stream: userData.stream,
//                                  semester: widget.semester,
//                                  subject: subjectname[index],
//                                  image: subjectThumbnail[index],
//                                )
                        )
                        );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Container(
                                width: 100,
                                height: 100,
                                child: subjectThumbnail[index] != null ? CachedNetworkImage(
                                  imageUrl: subjectThumbnail[index],
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ) : Image(
                                  image: AssetImage('assets/fancycolored.png'),
                                  fit: BoxFit.cover,)
                            ),
                              Container(
                                height: 80,
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    subjectname[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                        fontSize: 18.0,
                                        fontFamily: "SF-Pro-Text-Regular"
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

//  getSubjectCardPortrait(String imgpath, String subname, int index,
//      String semester, String stream, List colors) {
//    bool isPortrait;
//    var offsetWidth;
//    var offsetContainerWidth;
//    if (MediaQuery
//        .of(context)
//        .orientation == Orientation.portrait) {
//      isPortrait = true;
//      offsetWidth = 0.7;
//      offsetContainerWidth = 0.3;
//    } else {
//      isPortrait = false;
//      offsetWidth = 0.35;
//      offsetContainerWidth = 0.15;
//    }
//    var height = MediaQuery
//        .of(context)
//        .size
//        .height;
//    var width = MediaQuery
//        .of(context)
//        .size
//        .width;
//
//    var boxHeight = height * 0.55;
//    var boxWidth = width * offsetWidth;
//
//    return Padding(
//      padding: const EdgeInsets.only(right: 10),
//      child: ClipRRect(
//        borderRadius: BorderRadius.circular(20.0),
//        child: Container(
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//                colors: colors,
//              ),
//              boxShadow: [
//                BoxShadow(
//                    color: Colors.black12,
//                    offset: Offset(3.0, 6.0),
//                    blurRadius: 10.0)
//              ]),
//          width: width * offsetWidth,
//
//          child: Padding(
//            padding: const EdgeInsets.all(10),
//            child: Column(
//              children: [
//                Align(
//                  alignment: Alignment.topRight,
//                  child: Text(
//                    index.toString(),
//                    style: TextStyle(
//                        fontSize: 17.0,
//                        color: Colors.white
//                    ),
//                  ),
//                ),
//                Visibility(
//                  visible: isPortrait,
//                  child: SizedBox(
//                    height: height * 0.02,
//                  ),
//                ),
//                Container(
//                    width: height * 0.24,
//                    height: height * 0.24,
//                    child: imgpath != null ? CachedNetworkImage(
//                      imageUrl: imgpath,
//                      fit: BoxFit.cover,
//                      progressIndicatorBuilder: (context, url,
//                          downloadProgress) =>
//                          CircularProgressIndicator(
//                              value: downloadProgress.progress),
//                      errorWidget: (context, url, error) =>
//                          Icon(Icons.error),
//                    ) : Image(
//                      image: AssetImage('assets/fancycolored.png'),
//                      fit: BoxFit.cover,)
//                ),
//                Container(
//                  alignment: Alignment.bottomLeft,
//                  height: boxHeight * offsetContainerWidth,
//                  child: Text(subname,
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 25.0,
//                          fontFamily: "SF-Pro-Text-Regular")),
//                ),
//                SizedBox(height: 8.0,),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    roundButton(
//                          () {
//                        Navigator.push(context, MaterialPageRoute(
//                            builder: (context) =>
//                                ChapterList(semester: semester,
//                                  stream: stream,
//                                  subjectName: subname,
//                                  imageURL: imgpath,
//                                )
//                        )
//                        );
//                      },
//                      'Get Questions',
//                      Colors.blue,
//                    ),
//
//                    roundButton(
//                          () {
//                        Navigator.push(context, MaterialPageRoute(
//                            builder: (context) =>
//                                ShowNotes(
//                                  stream: stream,
//                                  semester: semester,
//                                  subject: subname,
//                                  image: imgpath,
//                                )
//                        )
//                        );
//                      },
//                      'Get Notes',
//                      Colors.purple,
//
//                    )
//                  ],
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//
//  Widget roundButton(Function onTap, String text, Color color) {
//    return GestureDetector(
//      onTap: onTap,
//      child: Container(
//        padding: EdgeInsets.symmetric(
//            horizontal: 10.0, vertical: 6.0),
//        decoration: BoxDecoration(
//            color: color,
//            borderRadius: BorderRadius.circular(
//                20.0)),
//        child: Text(text,
//            style: TextStyle(
//              color: Colors.white,
//            )),
//      ),
//    );
//  }
//}
}
