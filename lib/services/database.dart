import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:studyoverflow/models/user.dart';
import '../models/descmodel.dart';
class DatabaseServices{
  final uid;
  DatabaseServices({this.uid});
  CollectionReference dataCollection = Firestore.instance.collection('data');
  CollectionReference brewCollection = Firestore.instance.collection("users");
  CollectionReference brewCollectionQuestions = Firestore.instance.collection("brews");

  Future updateLikes(int likes,String question,String semester)async{
    return await brewCollectionQuestions.document(question+"-"+semester).updateData({
      'Like':likes,
    });
  }
  Future updateDisLikes(int dislikes,String question,String semester)async{
    return await brewCollectionQuestions.document(question+"-"+semester).updateData({
      'DisLike':dislikes,
    });
  }
  Future updateUserQuestion(String question,String answer,String subject,
      String course,String semester,String chapter,
      String diagram, String yearofrepeat,String marks,
      String name,int like,int disLike)async {
//    return await brewCollectionQuestions.document(question+"-"+semester).setData({
    return await dataCollection.document(course).collection(semester).document(subject.replaceAll("/", "-")).collection(chapter.replaceAll("/", "-")).document(question.replaceAll("/", "-")+semester).setData(
        {
      'Question': question,
      'Answer': answer,
      'Course': course,
      'Semester': semester,
      'Subject': subject,
      'Chapter': chapter,
      'Diagram':diagram,
      'YearOfRepeat':yearofrepeat,
      'Marks':marks,
      'UserID':uid,
      'PostedBy':name,
      'PostedOn':DateTime.now().toString(),
      'Like':like,
      'DisLike':disLike,
    });
  }
  Future updateUserData(String semester, String name, String stream)async{
    return await brewCollection.document(uid).setData({
      'Semester' : semester,
      'Name' : name,
      'Stream' : stream
    });
  }
  CollectionReference feedBack = Firestore.instance.collection("feedback");
  Future feedback(String name, String email, String phone,String feedback)async{
    return await feedBack.document(uid).setData({
      'Email' : email,
      'Name' : name,
      'Phone' : phone,
      'Feedback' : feedback,
    });
  }

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

  Future deleteData(String question,String semester,String diagram)async{
     if(diagram==null||diagram==''){
       await brewCollectionQuestions.document(question+'-'+semester).delete();
     }else{
       await brewCollectionQuestions.document(question+'-'+semester).delete();
       final StorageReference strref = FirebaseStorage.instance.ref().child(question);
       return await strref.delete();
     }

  }

  List<Data> _dataListFromSnapshot(QuerySnapshot snapshot){
  return snapshot.documents.map((doc){
  return Data(
        chapter: doc.data['Chapter']??'',
        answer:  doc.data['Answer']??'',
        course:  doc.data['Course']??'',
        question: doc.data['Question']??'',
        semester:  doc.data['Semester']??'',
        subject:  doc.data['Subject']??'',
        diagram: doc.data['Diagram']??'',
        yearofrepeat:doc.data['YearOfRepeat']??'',
        marks: doc.data['Marks']??'',
        thumbnail: doc.data['Thumbnail']??'',
        postedBy: doc.data['PostedBy']??'',
        postedOn: doc.data['PostedOn']??'',
        dislike: doc.data['DisLike']??0,
        like: doc.data['Like']??0,
  );
  }).toList();

  }
  Stream<List<Data>> dataAboutQues(String stream, String semester , String chapter,String subject){
//  return Firestore.instance.collection('brews').where('Course', isEqualTo: stream)
//      .where('Semester', isEqualTo: semester)
//      .where("Subject",isEqualTo:subject)
//      .where('Chapter',isEqualTo:chapter )
//      .snapshots().map(_dataListFromSnapshot);
    return Firestore.instance.collection('data')
        .document(stream)
        .collection(semester)
        .document(subject.replaceAll("/", "-"))
        .collection(chapter.replaceAll("/", "-"))
        .snapshots().map(_dataListFromSnapshot);
  }
  Stream<List<Data>> getMyContributions(){
    return Firestore.instance.collection('brews').where('UserID', isEqualTo: uid)
        .snapshots().map(_dataListFromSnapshot);
  }


  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data['Name'],
      semester:snapshot.data['Semester'],
      stream: snapshot.data['Stream'],
    );
  }

  //user data
  Stream<UserData> get userData{
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }


Stream<SubjectThumbnail> getThumbnail(String stream, String semester){
  return Firestore.instance.collection('imagecollection').document(stream+'-'+semester).snapshots().map(_subjectThumbnail);
}
  SubjectThumbnail _subjectThumbnail(DocumentSnapshot snapshot){
    return SubjectThumbnail(thumbnail:snapshot.data['subimg']);
  }



  Stream<ChapterNames> getChapterNames(String subjectname){
    return Firestore.instance.collection('chapternames').document(subjectname).snapshots().map(_chapterNames);
  }

  ChapterNames _chapterNames(DocumentSnapshot snapshot){
    return ChapterNames(chapternames:snapshot.data['chapters']);
  }

//----------getting stream names---------------//
  Stream<StreamNames> getStreamNames(String docname){
    return Firestore.instance.collection('stream').document(docname).snapshots().map(_streamNames);
  }

  StreamNames _streamNames(DocumentSnapshot snapshot){
    return StreamNames(streamnames:snapshot.data['streamlist']);
  }
}




