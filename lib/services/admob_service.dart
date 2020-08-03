import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Smart%20computer/AndroidStudioProjects/studyoverflow/lib/screens/allQuestions/description.dart';
class AdmobService{
  String getAdMobAppID(){
    if(Platform.isAndroid){
      return 'ca-app-pub-9118153038397153~5910414684';
    }
  }
  String getBannerAdID(){
    if(Platform.isAndroid){
      return 'ca-app-pub-9118153038397153/1410457549';
    }
  }
  String shortAnswer(String answer) {
    if (answer.length > 34) {
      return answer.substring(0, 30) + "....";
    } else {
      return answer;
    }
  }
  Widget listtileWithAd(index,
      BuildContext context,
      answer,
      question,
      chapter,
      diagram,
      yearofrepeat,
      marks,
      postedby,
      postedon,
      like,
      dislike,
      semester,
      keys,
      course
      ){
    return Column(
      children: [
        Center(
          child: AdmobBanner(
              adUnitId: "ca-app-pub-9118153038397153/1410457549",
              adSize: AdmobBannerSize.FULL_BANNER),
        ),
        Card(
          color: Color(0xFF2d3447),
          margin: EdgeInsets.fromLTRB(10,6,10,0),
          child: ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Description(answer:answer,
                question:question,chapter:chapter,diagram:diagram,
                yearofrepeat:yearofrepeat,marks:marks,postedBy:postedby,
                postedOn:postedon,like: like,dislike: dislike,semester:semester,
                keys: keys,course: course,
              )));
            },
            title: Text(question,style: TextStyle(color: Colors.white70),),
            subtitle: Text(shortAnswer(answer
                ??""),
              style: TextStyle(color: Colors.grey),
            ),
            leading: Text((index+1).toString(),
              style: TextStyle(color: Colors.grey),

            ),
            trailing: SizedBox(
              width: 100,
              child: AutoSizeText(yearofrepeat??"",
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget listtileWithoutAd(index,
      BuildContext context,
      answer,
      question,
      chapter,
      diagram,
      yearofrepeat,
      marks,
      postedby,
      postedon,
      like,
      dislike,
      semester,
      keys,
      course
      ){
    return Card(
      color: Color(0xFF2d3447),
      margin: EdgeInsets.fromLTRB(10,6,10,0),
      child: ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Description(answer:answer,
            question:question,chapter:chapter,diagram:diagram,
            yearofrepeat:yearofrepeat,marks:marks,postedBy:postedby,
            postedOn:postedon,like: like,dislike: dislike,semester: semester,
            keys: keys,course: course,
          )));
        },
        title: Text(question,style: TextStyle(color: Colors.white70),),
        subtitle: Text(shortAnswer(answer
            ??""),
          style: TextStyle(color: Colors.grey),
        ),
        leading: Text((index+1).toString(),
          style: TextStyle(color: Colors.grey),

        ),
        trailing: SizedBox(
          width: 100,
          child: AutoSizeText(yearofrepeat??"",
            style: TextStyle(
                fontSize: 10,
                color: Colors.grey
            ),
          ),
        ),
      ),
    );
  }

}