import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/myContribution/addQuestion.dart';
import 'file:///C:/Users/Smart%20computer/AndroidStudioProjects/studyoverflow/lib/screens/allQuestions/description.dart';
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
  List temp=['All'];
  List distinctSubjects=[];
  List<Data> mydata=[];
  List<Data> filteredmydata=[];
  List<Data> tempmydata=[];
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
    return StreamBuilder(
              stream:DatabaseServices(uid:user.uid).getMyContributions(),
              builder: (_ , snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Loading();
                }else{
                  mydata= snapshot.data;
                  for(int i=0;i<mydata.length;i++){
                    temp.add(mydata[i].subject);
                  }
                  filteredData(String label){
                    setState(() {
                      tempmydata=mydata.where((u) => u.subject.contains(label)).toList();
                    });
                  }
                  distinctSubjects=temp.toSet().toList();
                  if(tempmydata.isEmpty){
                    filteredmydata=mydata;
                  }else{
                    filteredmydata=tempmydata;
                  }
                  return Scaffold(
                    floatingActionButton: FloatingActionButton(
                      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddQuestion())),
                      child: Icon(Icons.add),
                      backgroundColor: Color(0xffD76EF5),
                    ),
                    body: SafeArea(
                        child: mydata.isEmpty?nothingToShow('By adding questions which are not available you can also contribute in the StudyOverflow community, your name will be reflected below the question you will add.', 'assets/contribute.png')
                            :Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child:ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                      itemCount: distinctSubjects.length,
                                    itemBuilder: (context,index){
                                        return GestureDetector(
                                          onTap: (){
                                            filteredData(distinctSubjects[index]);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Chip(
                                              avatar: CircleAvatar(
                                                backgroundColor: Color(0xffD76EF5),
                                                child: Text(
                                                  (index+1).toString(),
                                                    style: TextStyle(
                                                    fontSize: 10.0
                                                  ),
                                                ),
                                              ),
                                                label: Text(shortText(distinctSubjects[index], 7, 10))
                                            ),
                                          ),
                                        );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                  itemCount:tempmydata.isEmpty?mydata.length:filteredmydata.length,
                                  itemBuilder: (_, index){
                                    return Card(
                                      color: Color(0xFF2d3447),
                                      margin: EdgeInsets.fromLTRB(10,6,10,0),
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Description(answer:filteredmydata[index].answer,
                                            question:filteredmydata[index].question,chapter:filteredmydata[index].chapter,diagram:filteredmydata[index].diagram,
                                            yearofrepeat:filteredmydata[index].yearofrepeat,marks:filteredmydata[index].marks,postedBy:filteredmydata[index].postedBy,
                                            postedOn:filteredmydata[index].postedOn,like: filteredmydata[index].like,dislike: filteredmydata[index].dislike,semester: filteredmydata[index].semester,
                                          )));
                                        },
                                        title: Text(filteredmydata[index].question,style: TextStyle(color: Colors.white70),),
                                        subtitle: Text(shortText(filteredmydata[index].answer
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
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddQuestion(uanswer:filteredmydata[index].answer,
                                                      uquestion:filteredmydata[index].question,uchapter:filteredmydata[index].chapter,udiagram: filteredmydata[index].diagram,
                                                      uyearOfrepeat:filteredmydata[index].yearofrepeat,umarks:filteredmydata[index].marks, usubject: filteredmydata[index].subject,
                                                    )));
                                                  }),
                                              IconButton(
                                                  icon: Icon(Icons.delete,color: Colors.grey,),
                                                  onPressed: (){infoDialog(context, filteredmydata[index].question, filteredmydata[index].semester, filteredmydata[index].diagram);})
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                        ),
                                ),
                              ],
                            )
                    ),
                  );
                }
              },
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