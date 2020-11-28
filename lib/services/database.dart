import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:studyoverflow/models/notificationModel.dart';
import 'package:studyoverflow/models/user.dart';

import '../models/descmodel.dart';
class DatabaseServices{
  final uid;
  DatabaseServices({this.uid});
  //CollectionReference dataCollection = Firestore.instance.collection('data');
  CollectionReference userCollection = Firestore.instance.collection("users");
  //CollectionReference brewCollectionQuestions = Firestore.instance.collection("brews");

  final DatabaseReference database = FirebaseDatabase.instance.reference().child('test');
  final DatabaseReference notesNode = FirebaseDatabase.instance.reference()
      .child('notesNode');

//------------------------------LIke DisLike-------------------------------------------------------//
  Future updateLikes(int likes, String key, String course,
      DatabaseReference databaseReference) async {
    return await databaseReference.child(course).child(key).update({
      'Like':likes,
    });
  }

  Future updateDownloads(int downloads, String key, String course,
      DatabaseReference databaseReference) async {
    return await databaseReference.child(course).child(key).update({
      'Downloads': downloads,
    });
  }

  Future updateDisLikes(int dislikes, String key, String course,
      DatabaseReference databaseReference) async {
    return await databaseReference.child(course).child(key).update({
      'DisLike':dislikes,
    });
  }

//------------------------------Like Dislike-----------------------------------------------//


  //-----------------------set/update data-----------------------//
  Future setUserQuestion(String question,String answer,String subject,
      String course,String semester,String chapter,
      String diagram, String yearofrepeat,String marks,
      int like, int disLike, String key, String diagamID) async {
//    return await brewCollectionQuestions.document(question+"-"+semester).setData({
//    return await dataCollection.document(course).collection(semester).document(subject.replaceAll("/", "-")).collection(chapter.replaceAll("/", "-")).document(question.replaceAll("/", "-")+semester).setData(
//        {
    return await (key==null||key=='')?database.child(course).push().set({
      'Question': question,
      'Answer': answer,
      'Category':course+"-"+semester+"-"+subject+"-"+chapter,
      'Diagram':diagram,
      'DiagramID': diagamID,
      'YearOfRepeat':yearofrepeat,
      'Marks':marks,
      'PostedBy': uid,
      'PostedOn':DateTime.now().toString(),
      'Like':like,
      'DisLike':disLike,
    }):database.child(course).child(key).set({
      'Question': question,
      'Answer': answer,
      'Category':course+"-"+semester+"-"+subject+"-"+chapter,
      'Diagram':diagram,
      'DiagramID': diagamID,
      'YearOfRepeat':yearofrepeat,
      'Marks':marks,
      'PostedBy': uid,
      'PostedOn':DateTime.now().toString(),
      'Like':like,
      'DisLike':disLike,
    });
  }

  //-----------------------set/update data-----------------------//

  //------------------------add/Update notes--------------------//

  Future addNotes(String title, String notesURL, String thumbnailURL,
      String subject, String key, String course, String semester,
      String thumbnailID, String notesID, int like, int downloads, int size) async {
    return (key == null || key == '') ? notesNode.child(course).push().set({
      'Title': title,
      'PostedBy': uid,
      'Category': course + "-" + semester + "-" + subject,
      'ThumbnailURL': thumbnailURL,
      'ThumbnailID': thumbnailID,
      'NotesURL': notesURL,
      'NotesID': notesID,
      'PostedOn': DateTime.now().toString(),
      'Like': like,
      'Downloads': downloads,
      'Size':size,
    }) : notesNode.child(course).child(key).update({
      'Title': title,
      'PostedBy': uid,
      'Category': course + "-" + semester + "-" + subject,
      'ThumbnailURL': thumbnailURL,
      'ThumbnailID': thumbnailID,
      'NotesURL': notesURL,
      'NotesID': notesID,
      'PostedOn': DateTime.now().toString(),
      'Size':size,
    });
  }

  //------------------------add/Update notes--------------------//

  //----------------------update user data---------------------//
  Future updateUserData(String semester, String name, String stream,
      String profilePic) async {
    return await userCollection.document(uid).setData({
      'Semester' : semester,
      'Name' : name,
      'Stream': stream,
      'ProfilePic': profilePic,
    });
  }

  Future<bool> updateProfilePic(profilepic) async {
    try {
      await userCollection.document(uid).updateData({
        'ProfilePic': profilepic,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  //----------------------update user data---------------------//

  //----------------------send feedback-------------------------//

  CollectionReference feedBack = Firestore.instance.collection("feedback");
  Future feedback(String name, String email, String phone,String feedback)async{
    return await feedBack.document(uid).setData({
      'Email' : email,
      'Name' : name,
      'Phone' : phone,
      'Feedback' : feedback,
    });
  }

  //----------------------send feedback-------------------------//
//  Future getData(String semester, String stream, String subject,String chapter) async{
//    var firestore = Firestore.instance;
//    QuerySnapshot qn = await firestore.collection("brews")
//        .where('Course', isEqualTo: stream)
//        .where('Semester' , isEqualTo: semester)
//        .where("Subject",isEqualTo:subject)
//        .where('Chapter',isEqualTo:chapter )
//        .getDocuments();
//    return qn.documents;
//  }

  //--------------------------delete data--------------------------------//
  Future deleteQuestionsData(String diagramID, String course, String diagram,
      String key) async {
     if(diagram==null||diagram==''){
      // await brewCollectionQuestions.document(question+'-'+semester).delete();
       await database.child(course).child(key).remove();
     }else{
      // await brewCollectionQuestions.document(question+'-'+semester).delete();
       await database.child(course).child(key).remove();
       final StorageReference strref = FirebaseStorage.instance.ref().child(
           "diagrams/" + diagramID);
       return await strref.delete();
     }

  }

  Future deleteNotesData(String thumbnailID, String course, String notesID,
      String key) async {
    if (thumbnailID == null || thumbnailID == '') {
      await notesNode.child(course).child(key).remove();
      final StorageReference deleteNotes = FirebaseStorage.instance.ref().child(
          "notes/" + notesID + '.pdf');
      await deleteNotes.delete();
    } else {
      await notesNode.child(course).child(key).remove();
      final StorageReference strref = FirebaseStorage.instance.ref().child(
          "notesThumbnail/" + thumbnailID);
      await strref.delete();
      final StorageReference deleteNotes = FirebaseStorage.instance.ref().child(
          "notes/" + notesID + '.pdf');
      await deleteNotes.delete();
    }
  }

  //--------------------------delete data--------------------------------//

//  List<Data> _dataListFromSnapshot(QuerySnapshot snapshot){
//  return snapshot.documents.map((doc){
//  return Data(
//        chapter: doc.data['Chapter']??'',
//        answer:  doc.data['Answer']??'',
//        course:  doc.data['Course']??'',
//        question: doc.data['Question']??'',
//        semester:  doc.data['Semester']??'',
//        subject:  doc.data['Subject']??'',
//        diagram: doc.data['Diagram']??'',
//        yearofrepeat:doc.data['YearOfRepeat']??'',
//        marks: doc.data['Marks']??'',
//        thumbnail: doc.data['Thumbnail']??'',
//        postedBy: doc.data['PostedBy']??'',
//        postedOn: doc.data['PostedOn']??'',
//        dislike: doc.data['DisLike']??0,
//        like: doc.data['Like']??0,
//  );
//  }).toList();
//
//  }
//  Stream<List<Data>> dataAboutQues(String stream, String semester , String chapter,String subject){
////  return Firestore.instance.collection('brews').where('Course', isEqualTo: stream)
////      .where('Semester', isEqualTo: semester)
////      .where("Subject",isEqualTo:subject)
////      .where('Chapter',isEqualTo:chapter )
////      .snapshots().map(_dataListFromSnapshot);
//    return Firestore.instance.collection('data')
//        .document(stream)
//        .collection(semester)
//        .document(subject.replaceAll("/", "-"))
//        .collection(chapter.replaceAll("/", "-"))
//        .snapshots().map(_dataListFromSnapshot);
//  }
//  Stream<List<Data>> getMyContributions(){
//    return Firestore.instance.collection('brews').where('UserID', isEqualTo: uid)
//        .snapshots().map(_dataListFromSnapshot);
//  }

//---------------------------get user data------------------------------------//
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
        name: snapshot.data['Name'] ?? '',
        semester: snapshot.data['Semester'] ?? '',
        stream: snapshot.data['Stream'] ?? '',
        profilepic: snapshot.data['ProfilePic'] ?? ''
    );
  }

  //user data
  Stream<UserData> get userData{
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

//---------------------------get user data------------------------------------//

  //-----------------------------------get thumbnail-----------------------------------//
Stream<SubjectThumbnail> getThumbnail(String stream, String semester){
  return Firestore.instance.collection('imagecollection').document(stream+'-'+semester).snapshots().map(_subjectThumbnail);
}
  SubjectThumbnail _subjectThumbnail(DocumentSnapshot snapshot){
    return SubjectThumbnail(thumbnail:snapshot.data['subimg']);
  }

//----------------------------------get thumbnails---------------------------------//

  //----------------------------------get chapter names-------------------------------//

  Stream<ChapterNames> getChapterNames(String subjectname){
    return Firestore.instance.collection('chapternames').document(subjectname).snapshots().map(_chapterNames);
  }

  ChapterNames _chapterNames(DocumentSnapshot snapshot){
    return ChapterNames(chapternames:snapshot.data['chapters']);
  }

  //----------------------------------get chapter names-------------------------------//

  //------------------------------get notifications-----------------------------------//

  Stream<NotificationModel> getNotifications(){
    return Firestore.instance.collection('alerts').document('notifications').snapshots().map(_notifications);
  }
  NotificationModel _notifications(DocumentSnapshot snapshot){
    return NotificationModel(notifications:snapshot.data['nots']);
  }

  //------------------------------get notifications-----------------------------------//

  //-------------------------------get links----------------------------------------//
  Stream<ImpLinksModel> getLinks(){
    return Firestore.instance.collection('importantLinks').document('implinksDoc').snapshots().map(_impLinks);
  }
  ImpLinksModel _impLinks(DocumentSnapshot snapshot){
    return ImpLinksModel(links:snapshot.data['implinks']);
  }

  //-------------------------------get links----------------------------------------//

  //--------------------------get subjects---------------------------------------------//

  Stream<SubjectsModel> getSubjects(String stream){
    return Firestore.instance.collection('subjectcollection').document(stream).snapshots().map(_subjects);
  }
  SubjectsModel _subjects(DocumentSnapshot snapshot){
    return SubjectsModel(subjects:snapshot.data['subjects']);
  }
  //--------------------------get subjects---------------------------------------------//



//------------------------------------------get stream names---------------------------------------//
  Stream<StreamNames> getStreamNames(String docname){
    return Firestore.instance.collection('stream').document(docname).snapshots().map(_streamNames);
  }

  StreamNames _streamNames(DocumentSnapshot snapshot){
    return StreamNames(streamnames:snapshot.data['streamlist']);
  }

//------------------------------------------get stream names---------------------------------------//

  deleteImage(String path, String id) async {
    final StorageReference strref = FirebaseStorage.instance.ref().child(
        path + id);
    await strref.delete();
  }


}




