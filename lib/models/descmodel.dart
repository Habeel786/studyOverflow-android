class Data{
   final String key;
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
   final int like;
   final int dislike;
   final String diagramId;
   Data({this.key,this.question, this.answer, this.course, this.semester, this.subject,
       this.chapter,this.diagram,this.yearofrepeat,this.marks,this.thumbnail,this.postedBy,this.postedOn,
     this.like, this.dislike, this.diagramId
   });
}
class NewData{
   String question;
   List answer;
   String course;
   String semester;
   String subject;
   String chapter;
   List diagram;
   String thumbnail;
   String marks;
   String postedBy;
   String postedOn;
   int like;
   int dislike;
   String key;
   List diagramId;

   NewData({this.question, this.answer, this.course, this.semester, this.subject,
      this.chapter,this.diagram,this.marks,this.thumbnail,this.postedBy,this.postedOn,
      this.like,this.dislike,this.key,this.diagramId
   });
}
class CheckUpdates{
   final bool updates;
   final String version;
   CheckUpdates({this.updates,this.version});
}

class ChapterNames{
   final List chapternames;
   ChapterNames({this.chapternames});
}
class StreamNames{
   final List streamnames;
   StreamNames({this.streamnames});
}