import 'package:admob_flutter/admob_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/services/admob_service.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/screens/home/description.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';


class Demo extends StatefulWidget {
  //final List sharedprefdata;
  final String subject;
  final String semester;
  final String stream;
  final String chapter;

  Demo({this.subject,this.semester,this.stream,this.chapter});

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  var _data;
  bool adFlag=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Admob.initialize('ca-app-pub-9118153038397153~5910414684');
    _data= DatabaseServices().dataAboutQues( widget.stream,widget.semester, widget.chapter,widget.subject);
  }
  @override
  Widget build(BuildContext context) {
    String answer="";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Questions'),
        centerTitle: true,
        backgroundColor: Color(0xffD76EF5),
      ),
      body: StreamBuilder(
        stream:_data,
        builder: (_ , snapshot){
          List<Data> mydata= snapshot.data;
          if(snapshot.connectionState==ConnectionState.waiting){
            return Loading();
          }else{
            return mydata.isEmpty?nothingToShow("Data is to be added",'assets/notfound.png'):
            ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index){
                  if((index+1)%11==0){
                    adFlag=true;
                  }else{
                    adFlag=false;
                  }
                  return  adFlag?AdmobService().listtileWithAd(index,context,mydata[index].answer,
                    mydata[index].question,mydata[index].chapter,mydata[index].diagram,
                    mydata[index].yearofrepeat,mydata[index].marks,mydata[index].postedBy,
                    mydata[index].postedOn,
                  ):AdmobService().listtileWithoutAd(index,context,mydata[index].answer,
                    mydata[index].question,mydata[index].chapter,mydata[index].diagram,
                    mydata[index].yearofrepeat,mydata[index].marks,mydata[index].postedBy,
                    mydata[index].postedOn,
                  );
                });
          }
        },
      ),
    );
  }
}
