import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/myContribution/addQuestion.dart';
import 'package:studyoverflow/screens/home/description.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';

class MyContributions extends StatefulWidget {
  var _data;

  @override
  _MyContributionsState createState() => _MyContributionsState();
}

class _MyContributionsState extends State<MyContributions> {
  Future<bool> doDelete;
  String shortText(String text,int maxlength,int limit) {
    if (text.length > maxlength) {
      return text.substring(0, limit) + "....";
    } else {
      return text;
    }
  }
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
                  return mydata.isEmpty?nothingToShow('By adding questions which are not available you can also contribute in the StudyOverflow community, your name will be reflected below the question you will add.', 'assets/contribute.png')
                      :ListView.builder(
                      itemCount: mydata.length,
                      itemBuilder: (_, index){
                        return Card(
                          color: Color(0xFF2d3447),
                          margin: EdgeInsets.fromLTRB(10,6,10,0),
                          child: ListTile(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Description(answer:mydata[index].answer,
                                question:mydata[index].question,chapter:mydata[index].chapter,diagram:mydata[index].diagram,
                                yearofrepeat:mydata[index].yearofrepeat,marks:mydata[index].marks,postedBy:mydata[index].postedBy,
                                postedOn:mydata[index].postedOn,
                              )));
                            },
                            title: Text(mydata[index].question,style: TextStyle(color: Colors.white70),),
                            subtitle: Text(shortText(mydata[index].answer
                                ??"",34,30),
                              style: TextStyle(color: Colors.grey),
                            ),
                            leading: Text((index+1).toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.edit,color: Colors.grey,),
                                      onPressed: (){
                                        print(mydata[index].diagram);
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddQuestion(uanswer:mydata[index].answer,
                                          uquestion:mydata[index].question,uchapter:mydata[index].chapter,udiagram: mydata[index].diagram,
                                          uyearOfrepeat:mydata[index].yearofrepeat,umarks:mydata[index].marks, usubject: mydata[index].subject,
                                        )));
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.delete,color: Colors.grey,),
                                      onPressed: (){infoDialog(context, mydata[index].question, mydata[index].semester, mydata[index].diagram);})
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      );
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
        return AlertDialog(
          backgroundColor: Color(0xFF2d3447),
          title: Text('Delete?',style: TextStyle(color: Colors.grey),),
          content: Text('Delete this item?',style: TextStyle(color: Colors.grey)),
          actions: [
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('No')),
            FlatButton(onPressed: ()async{
              DatabaseServices().deleteData(question,semester,diagram);
              Navigator.of(context).pop();
              }, child: Text('Yes')),
          ],
        );
    }
  );
}