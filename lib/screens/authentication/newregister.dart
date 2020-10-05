import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studyoverflow/drawerScreens/termsAndConditions.dart';
import 'package:studyoverflow/services/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/services/auth.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/widgets/gradientbutton.dart';

class NewRegister extends StatefulWidget {
  final Function toggleView;

  NewRegister({this.toggleView});

  @override
  _NewRegisterState createState() => _NewRegisterState();
}

class _NewRegisterState extends State<NewRegister> {
  final _formkey = GlobalKey<FormState>();
  final _auth= AuthService();
  String email= "";
  String password= "";
  String name="";
  String _currentSemester;
  String _currentStream;
  List streams=['computer engineering','civil engineering','mechanical engineering','electronics','electrical engineering'];
  List semesters=['1','2','3','4','5','6'];
  String error="";
  bool loading= false;

  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [Color(0xffD76EF5), Color(0xff8F7AFE)]
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(1, Text("Register",
                      style: TextStyle(color: Colors.white, fontSize: 40),)),
                    SizedBox(height: 10,),
                    FadeAnimation(1.3, Text("Study OverFlow",
                      style: TextStyle(color: Colors.white, fontSize: 18),)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF2d3447),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 60,),
                              FadeAnimation(1.4, Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF2d3447),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(
                                        color: Color(0xffD76EF5),
                                        blurRadius: 20,
                                        offset: Offset(0, 3)
                                    )
                                    ]
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(
                                              color: Colors.grey))
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.grey),
                                        validator: (val) =>
                                        val.isEmpty || (!val.contains('.com'))
                                            ? "Enter Valid Email"
                                            : null,
                                        onChanged: (val) {
                                          setState(() {
                                            email = val;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            labelText: "Email",
                                            labelStyle: TextStyle(
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(
                                              color: Colors.grey))
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.grey),
                                        obscureText: true,
                                        onChanged: (val) {
                                          setState(() {
                                            password = val;
                                          });
                                        },
                                        validator: (val) =>
                                        val.length < 6
                                            ? "Password Must Be 8 Chars Long"
                                            : null,
                                        decoration: InputDecoration(
                                            labelText: "Password",
                                            labelStyle: TextStyle(
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(
                                              color: Colors.grey))
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.grey),
                                        onChanged: (val) {
                                          setState(() {
                                            name = val.trim();
                                          });
                                        },
                                        validator: (val) =>
                                        val.length < 6
                                            ? "Name Must be At least 6 chars long"
                                            : null,
                                        decoration: InputDecoration(
                                            labelText: "Name",
                                            labelStyle: TextStyle(
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(
                                              color: Colors.grey))
                                      ),
                                      child: DropdownButtonFormField(
                                        validator: (val) {
                                          return val == null
                                              ? "Stream Empty"
                                              : null;
                                        },
                                        dropdownColor: Color(0xFF2d3447),
                                        style: TextStyle(color: Colors.grey),
                                        isExpanded: true,
                                        value: _currentStream,
                                        items: streams.map((stream) {
                                          return DropdownMenuItem(
                                            value: stream,
                                            child: Text("$stream"),
                                          );
                                        }).toList(),
                                        onChanged: (val) => setState(() =>
                                        _currentStream = val),
                                        decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                                color: Colors.grey),
                                            hintStyle: TextStyle(
                                                color: Colors.grey),
                                            labelText: 'Stream',
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(
                                              color: Colors.grey))
                                      ),
                                      child: DropdownButtonFormField(
                                        validator: (val) {
                                          return val == null
                                              ? "Semester Empty"
                                              : null;
                                        },
                                        style: TextStyle(color: Colors.grey),
                                        value: _currentSemester,
                                        dropdownColor: Color(0xFF2d3447),
                                        items: semesters.map((semester) {
                                          return DropdownMenuItem(
                                            value: semester,
                                            child: Text("$semester"),
                                          );
                                        }).toList(),
                                        onChanged: (val) => setState(() =>
                                        _currentSemester = val),
                                        decoration: InputDecoration(
                                            labelText: "Semester",
                                            labelStyle: TextStyle(
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      //child: Text("By continuing, you agree to studyOverflow's terms and conditions"),
                                      child: tandCText(context),
                                    )
                                  ],
                                ),
                              )
                              ),
                              SizedBox(height: 40,),
                              Column(
                                children: <Widget>[
                                  FadeAnimation(1.6,
                                      GradientButton(
                                        text: 'Register',
                                        onTap: () async {
                                          if (_formkey.currentState
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            dynamic results = await _auth
                                                .registerWithEmailAndPassword(
                                                email, password, name,
                                                _currentSemester,
                                                _currentStream);
                                            if (results == null) {
                                              setState(() {
                                                loading = false;
                                                Fluttertoast.showToast(
                                                  msg: 'Failed To Register',
                                                  toastLength: Toast
                                                      .LENGTH_SHORT,);
                                              });
                                            }
                                          }
                                        },
                                      )
                                  ),
                                  SizedBox(height: 20,),
                                  FadeAnimation(1.7, Text(
                                    "Already have an account?",
                                    style: TextStyle(color: Colors.grey),)),
                                  SizedBox(height: 20,),
                                  FadeAnimation(1.6,
                                      GradientButton(
                                        text: 'Login',
                                        onTap: () {
                                          widget.toggleView();
                                        },
                                      )
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
