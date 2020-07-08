import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/myContribution/addQuestion.dart';
import 'package:studyoverflow/services/admob_service.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/shared/loading.dart';

class MyContributions extends StatefulWidget {
  var _data;

  @override
  _MyContributionsState createState() => _MyContributionsState();
}

class _MyContributionsState extends State<MyContributions> {
  bool adFlag=false;
  Future<bool> doDelete;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10,left: 10),
            child:  StreamBuilder(
              stream:DatabaseServices(uid:user.uid).getMyContributions(),
              builder: (_ , snapshot){
                List<Data> mydata= snapshot.data;
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Loading();
                }else{
                  return ListView.builder(
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
          )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddQuestion())),
        child: Icon(Icons.add),
        backgroundColor: Color(0xffD76EF5),
      ),
    );
  }
}
Future<bool> infoDialog(context,question,semester,diagram){
  return showDialog(
      context: context,
    barrierDismissible: true,
    builder: (BuildContext context){
        return CupertinoAlertDialog(
          title: Text('Delete?'),
          content: Text('Delete this item?'),
          actions: [
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('No')),
            FlatButton(onPressed: ()async{
              await DatabaseServices().deleteData(question,semester,diagram);
              Navigator.of(context).pop();
              }, child: Text('Yes')),
          ],
        );
    }
  );
}