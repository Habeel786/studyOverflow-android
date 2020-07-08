//import 'package:flutter/material.dart';
//import 'package:studyoverflow/Animation/FadeAnimation.dart';
//import 'package:studyoverflow/screens/home/home.dart';
//import 'package:studyoverflow/services/auth.dart';
//import 'package:studyoverflow/services/saveSharedPreference.dart';
//import 'package:studyoverflow/shared/loading.dart';
//class Preference extends StatefulWidget {
//  @override
//  _PreferenceState createState() => _PreferenceState();
//}
//
//class _PreferenceState extends State<Preference> {
//  List streams=['computer engineering','BSC','Commerce','Arts','Civil Engineering','Electronics And Communication',];
//  List semesters=['1','2','3','4','5','6','7','8'];
//  String semester;
//  String stream;
//  String email;
//  String password;
//  String _currentStream;
//  String _currentSemester;
//  final _auth = AuthService();
//  final _savedata= SaveData();
//  String error;
//  final _formkey = GlobalKey<FormState>();
//  bool loading=false;
//  getData() async{
//    semester = await SaveData().getData('semester');
//    stream = await SaveData().getData('stream');
//  }
//  initialize() async{
//    await getData();
//    print(semester);
//    print(stream);
//  }
//  @override
//  void initState() {
//    super.initState();
//
//  }
//  @override
//  Widget build(BuildContext context) {
//    return loading?Loading():Scaffold(
//      body: Container(
//        width: double.infinity,
//        decoration: BoxDecoration(
//          //color: //Color(0xFF1e3d59)
//            gradient: LinearGradient(
//                begin: Alignment.topCenter,
//                colors: [
//                  Colors.orange[900],
//                  Colors.orange[800],
//                  Colors.orange[400]
//                ]
//            )
//        ),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            SizedBox(height: 80,),
//            Padding(
//              padding: EdgeInsets.all(20),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  FadeAnimation(1, Text("Preference", style: TextStyle(color: Colors.white, fontSize: 40),)),
//                  SizedBox(height: 10,),
//                  FadeAnimation(1.3, Text("Fill the information so we can show you relevent results", style: TextStyle(color: Colors.white, fontSize: 18),)),
//                ],
//              ),
//            ),
//            SizedBox(height: 20),
//            Expanded(
//              child: Container(
//                decoration: BoxDecoration(
//                    color: Colors.white,
//                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
//                ),
//                child: SingleChildScrollView(
//                  child: Padding(
//                    padding: EdgeInsets.all(30),
//                    child: Form(
//                      key: _formkey,
//                      child: Column(
//                        children: <Widget>[
//                          SizedBox(height: 60,),
//                          FadeAnimation(1.4, Container(
//                            decoration: BoxDecoration(
//                                color: Colors.white,
//                                borderRadius: BorderRadius.circular(10),
//                                boxShadow: [BoxShadow(
//                                    color: Colors.orange,
//                                    blurRadius: 20,
//                                    offset: Offset(0, 10)
//                                )]
//                            ),
//                            child: Column(
//                              children: <Widget>[
//                                //----------------------------STREAM------------------------//
//                                Container(
//                                  padding: EdgeInsets.all(10),
//                                  decoration: BoxDecoration(
//                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
//                                  ),
//                                  child: DropdownButtonFormField(
//                                    value: _currentStream,
//                                    items: streams.map((stream){
//                                      return DropdownMenuItem(
//                                        value: stream,
//                                        child: Text("$stream"),
//                                      );
//                                    }).toList(),
//                                    onChanged: (val)=> setState(()=>_currentStream=val),
//                                    decoration: InputDecoration(
//                                        hintText: "Stream",
//                                        hintStyle: TextStyle(color: Colors.grey),
//                                        border: InputBorder.none
//                                    ),
//                                  ),
//                                ),
//                                //----------------------------Stream----------------------//
//
//
//                                //---------------------------SEMESTER----------------------//
//                                Container(
//                                  padding: EdgeInsets.all(10),
//                                  decoration: BoxDecoration(
//                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
//                                  ),
//                                  child: DropdownButtonFormField(
//                                    value: _currentSemester,
//                                    items: semesters.map((semester){
//                                      return DropdownMenuItem(
//                                        value: semester,
//                                        child: Text("$semester"),
//                                      );
//                                    }).toList(),
//                                    onChanged: (val)=> setState(()=>_currentSemester=val),
//                                    decoration: InputDecoration(
//                                        hintText: "Semester",
//                                        hintStyle: TextStyle(color: Colors.grey),
//                                        border: InputBorder.none
//                                    ),
//                                  ),
//                                ),
//                                //---------------------------SEMESTER----------------------//
//                              ],
//                            ),
//                          )),
//                          SizedBox(height: 60,),
//                          Column(
//                            children: <Widget>[
//                              //-----------------Proceed BUTTON---------------//
//                              FadeAnimation(1.6, GestureDetector(
//                                onTap: ()async{
//                                  print(_currentSemester);
//                                  print(_currentStream);
//                                  _savedata.setData("semester", _currentSemester);
//                                  _savedata.setData("stream", _currentStream);
//                                  initialize();
//                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home(stream: stream,semester: semester,)));
//                                },
//                                child: Container(
//                                  height: 50,
//                                  margin: EdgeInsets.symmetric(horizontal: 50),
//                                  decoration: BoxDecoration(
//                                      borderRadius: BorderRadius.circular(50),
//                                      gradient: LinearGradient(
//                                          begin: Alignment.topCenter,
//                                          colors: [
//                                            Colors.orange[900],
//                                            Colors.orange[800],
//                                            Colors.orange[400]
//                                          ]
//                                      )
//                                  ),
//                                  child: Center(
//                                    child: Text("Proceed", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
//                                  ),
//                                ),
//                              )),
//                              //-----------------Proceed BUTTON ends---------------//
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
