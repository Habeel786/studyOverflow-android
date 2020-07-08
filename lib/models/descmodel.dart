import 'package:cloud_firestore/cloud_firestore.dart';

class Data{
   final String question;
   final String answer;
   final String course;
   final String semester;
   final String subject;
   final String chapter;
   final String diagram;
   final String thumbnail;
   final String yearofrepeat;
   final String marks;
   final dynamic postedBy;
   final dynamic postedOn;


   Data({this.question, this.answer, this.course, this.semester, this.subject,
       this.chapter,this.diagram,this.yearofrepeat,this.marks,this.thumbnail,this.postedBy,this.postedOn});
}
class SubjectThumbnail{
   final Map thumbnail;
   SubjectThumbnail({this.thumbnail});
}

class ChapterNames{
   final List chapternames;
   ChapterNames({this.chapternames});
}