import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/shared/loading.dart';
class NewShowData extends StatefulWidget {
  @override
  _NewShowDataState createState() => _NewShowDataState();
}

class _NewShowDataState extends State<NewShowData> {
  List<Data> mydata= [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //setData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.reference().child('test').child('computer engineering')
      .orderByChild('Chapter').equalTo('Data structures in python')
          .onValue,
      builder: (context,AsyncSnapshot<Event> snapshot){
        mydata.clear();
       if(snapshot.hasData){
         Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
         map.forEach((dynamic, v){
           mydata.add(new Data(
             chapter: v['Chapter']??'',
             answer:  v['Answer']??'',
             course:  v['Course']??'',
             question: v['Question']??'',
             semester:  v['Semester']??'',
             subject:  v['Subject']??'',
             diagram: v['Diagram']??'',
             yearofrepeat:v['YearOfRepeat']??'',
             marks: v['Marks']??'',
             thumbnail: v['Thumbnail']??'',
             postedBy: v['PostedBy']??'',
             postedOn: v['PostedOn']??'',
             dislike: v['DisLike']??0,
             like: v['Like']??0,
           ));
         });
         return Scaffold(
           body: SafeArea(
               child: ListView.builder(
                   itemCount: mydata.length,
                   itemBuilder: (context,index){
                     return ListTile(
                       title: Text(mydata[index].question),
                     );
                   }
               )
           ),
         );
       }else{
         return Loading();
       }
      },
    );
  }
}
