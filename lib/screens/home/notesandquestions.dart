import 'package:flutter/material.dart';
import 'package:studyoverflow/chapter/listchapter.dart';
import 'package:studyoverflow/screens/notes/showNotes.dart';

class NotesAndQuestions extends StatefulWidget {
  String subjectname;
  String semester;
  String stream;
  String imageURL;


  NotesAndQuestions({this.subjectname,this.stream,this.semester,this.imageURL});

  @override
  _NotesAndQuestionsState createState() => _NotesAndQuestionsState();
}

class _NotesAndQuestionsState extends State<NotesAndQuestions> with AutomaticKeepAliveClientMixin {



 @override
 bool get wantKeepAlive => true;

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2d3447),
          title: Text(widget.subjectname),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Notes And Sample Papers',),
              Tab(text: 'Questions And Topics',)
            ],
          ),
        ),
         body: TabBarView(
           children: [
             ShowNotes(
               stream: widget.stream,
               semester: widget.semester,
               subject: widget.subjectname,
             ), ChapterList(semester: widget.semester,
               stream: widget.stream,
               subjectName: widget.subjectname,
               imageURL: widget.imageURL,
             )

           ],
         ),
      ),
    );
  }
}
