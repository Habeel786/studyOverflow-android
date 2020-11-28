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
}
