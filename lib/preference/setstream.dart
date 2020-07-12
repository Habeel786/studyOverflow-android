import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/Animation/FadeAnimation.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/shared/loading.dart';
class SetStream extends StatefulWidget {
  @override
  _SetStreamState createState() => _SetStreamState();
}

class _SetStreamState extends State<SetStream> {

  final _formkey = GlobalKey<FormState>();
  List semesters=['1','2','3','4','5','6'];
  List streams=['computer engineering','civil engineering','mechanical engineering','electronics','electrical engineering'];
  String _currentStream;
  String _currentSemester;
  String name;

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
   return StreamBuilder(
      stream: DatabaseServices(uid: user.uid).userData,
      builder: (context,snapshot){
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: Icon(Icons.menu), onPressed: ()=>Scaffold.of(context).openDrawer()),
              backgroundColor: Color(0xFF2d3447),
              elevation: 0.0,
              centerTitle: true,
              title: Text('Profile'),
            ),
            resizeToAvoidBottomPadding: false,
              resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left:30.0,right: 30.0,),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        //--------------stream--------------//
                        FadeAnimation(0.5,
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[200]))
                            ),
                            child: DropdownButtonFormField(
                              dropdownColor: Color(0xFF2d3447),
                              style: TextStyle(color: Colors.grey),
                              isExpanded: true,
                              value: _currentStream??userData.stream,
                              items: streams.map((stream){
                                return DropdownMenuItem(
                                  value: stream,
                                  child: Text("$stream"),
                                );
                              }).toList(),
                              onChanged: (val)=> setState(()=>_currentStream=val),
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: 'Stream',
                                  border: InputBorder.none
                              ),
                            ),
                          ),
//                          Container(
//                            padding: EdgeInsets.all(10),
//                            decoration: BoxDecoration(
//                                border: Border(bottom: BorderSide(color: Colors.grey[200]))
//                            ),
//                            child: StreamBuilder(
//                                stream: DatabaseServices().getStreamNames('streams'),
//                                builder: (context, snapshot) {
//                                  if(snapshot.hasData){
//                                    StreamNames streamNames = snapshot.data;
//                                    List names=streamNames.streamnames;
//                                    return DropdownButtonFormField(
//                                      dropdownColor: Color(0xFF2d3447),
//                                      style: TextStyle(color: Colors.grey),
//                                      isExpanded: true,
//                                      value: _currentStream??userData.stream,
//                                      items: names.map((stream){
//                                        return DropdownMenuItem(
//                                          value: stream,
//                                          child: Text("$stream"),
//                                        );
//                                      }).toList(),
//                                      onChanged: (val)=> setState(()=>_currentStream=val),
//                                      decoration: InputDecoration(
//                                          labelStyle: TextStyle(color: Colors.white),
//                                          hintStyle: TextStyle(color: Colors.grey),
//                                          labelText: 'Stream',
//                                          border: InputBorder.none
//                                      ),
//                                    );
//                                  }else{
//                                    return Text('loading...',style: TextStyle(color: Colors.grey),);
//                                  }
//
//                                }
//                            ),
//                          ),
                        ),
                        //--------------stream--------------//

                        //---------------semester------------//
                        FadeAnimation(0.5,
                          Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]))
                          ),
                          child: DropdownButtonFormField(
                            style: TextStyle(color: Colors.grey),
                            dropdownColor: Color(0xFF2d3447),
                            value:_currentSemester??userData.semester,
                            items: semesters.map((semester){
                              return DropdownMenuItem(
                                value: semester,
                                child: Text("$semester"),
                              );
                            }).toList(),
                            onChanged: (val)=> setState(()=>_currentSemester=val),
                            decoration: InputDecoration(
                              labelText: 'Semester',
                                labelStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        ),
                        FadeAnimation(0.5, Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]))
                          ),
                          child: TextFormField(
                            style: TextStyle(color: Colors.grey),
                            initialValue:userData.name,
                            onChanged: (val){
                              setState(() {
                                 name=val;
                              });
                            },
                            validator: (val)=>val.length<6?"Name Must Not Be Empty": null,
                            decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        ),
                        //----------------semester-----------//
                        SizedBox(height: 40,),
                        FadeAnimation(0.5, InkWell(
                          onTap: ()async{
                            if(_formkey.currentState.validate()){
                              print(_currentSemester);
                              print(_currentStream);
                              await DatabaseServices(uid: user.uid).updateUserData(
                                  _currentSemester ?? userData.semester,
                                  name??userData.name,
                                  _currentStream?? userData.stream);
                              Fluttertoast.showToast(
                                msg: 'Data Updated',
                                toastLength: Toast.LENGTH_SHORT,);
                            }

                            //Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> Home()));

                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    colors: [
                                      Color(0xffD76EF5), Color(0xff8F7AFE)
                                    ]
                                )
                            ),
                            child: Center(
                              child: Text("Update", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }else{
          return Loading();
        }
      },
    );
  }
}
