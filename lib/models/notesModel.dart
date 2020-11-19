class NotesModel {
  final String title;
  final String postedBy;
  final String course;
  final String semseter;
  final String thumbnailURL;
  final String thumbnailID;
  final String notesURL;
  final String notesID;
  final String postedON;
  final int like;
  final int downloads;
  final String keys;
  final String subject;
  final int fileSize;

  NotesModel(
      {this.title,
      this.postedBy,
      this.course,
      this.semseter,
      this.thumbnailURL,
      this.thumbnailID,
      this.notesURL,
      this.notesID,
      this.postedON,
      this.like,
      this.downloads,
      this.keys,
      this.subject,
      this.fileSize});
}
