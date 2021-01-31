import 'dart:io';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/screens/allQuestions/description.dart';
import 'package:flutter/material.dart';

class AdmobService{
  String shortText(String answer,int length) {
    if (answer.length > length) {
      return answer.substring(0, length-4) + "....";
    } else {
      return answer;
    }
  }
  Widget listtileWithoutAd(BuildContext context, NewData mydata,int index,List<Color> themeColor){
    return Card(
      color: Color(0xFF2d3447),
      margin: EdgeInsets.fromLTRB(10,6,10,0),
      child: ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Description(mydata: mydata,themeColor: themeColor,)));
        },
        title: Text(shortText(mydata.question,100),style: TextStyle(color: Colors.white70),),
        subtitle: Text(shortText(mydata.answer[0]??"",34),
          style: TextStyle(color: Colors.grey),
        ),
        leading: Text((index+1).toString(),
          style: TextStyle(color: Colors.grey),

        ),
//        trailing: SizedBox(
//          width: 40,
//          child: Text(
//            yearofrepeat,
//            style: TextStyle(color: Colors.grey),
//          ),
//        )
      ),
    );
  }

}