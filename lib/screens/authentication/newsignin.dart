import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studyoverflow/screens/authentication/forgotPassword.dart';
import 'package:studyoverflow/services/Animation/FadeAnimation.dart';
import 'package:studyoverflow/services/auth.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/widgets/gradientbutton.dart';

class NewSignin extends StatefulWidget {
  final Function toggleView;
  NewSignin({this.toggleView});
  @override
  _NewSigninState createState() => _NewSigninState();
}

class _NewSigninState extends State<NewSignin> {
  final _formkey = GlobalKey<FormState>();
  final _auth= AuthService();
  String email= "";
  String password= "";
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
                    FadeAnimation(1, Text("Login",
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
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(
                                              color: Colors.grey))
                                      ),
                                      child: TextFormField(
                                        validator: (val) =>
                                        val.isEmpty || (!val.contains('.com'))
                                            ? "Enter Valid Email"
                                            : null,
                                        style: TextStyle(color: Colors.grey),
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
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(
                                              color: Colors.grey))
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.grey),
                                        obscureText: true,
                                        onChanged: (val) {
                                          setState(() {
                                            password = val;
                                          }
                                          );
                                        },
                                        validator: (val) =>
                                        val.length < 6
                                            ? "Password Must Be 6 Chars Long"
                                            : null,
                                        decoration: InputDecoration(
                                            labelText: "Password",
                                            labelStyle: TextStyle(
                                                color: Colors.grey),
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: tandCText(context),
                                    ),
                                  ],
                                ),
                              )
                              ),
                              SizedBox(height: 40,),
                              FadeAnimation(1.5,
                                  GestureDetector(
                                    onTap: () => Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            ForgotPassword())),
                                    child: Text("Forgot Password?",
                                      style: TextStyle(color: Colors.grey),),
                                  )),
                              SizedBox(height: 40,),
                              Column(
                                children: <Widget>[
                                  //-----------------LOGIN BUTTON---------------//
                                  FadeAnimation(1.6,
                                      GradientButton(
                                        text: 'Login',
                                        onTap: () async {
                                          if (_formkey.currentState
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            dynamic results = await _auth
                                                .signInWithEmailAndPassword(
                                                email, password);
                                            if (results == null) {
                                              setState(() {
                                                loading = false;
                                                Fluttertoast.showToast(
                                                  msg: 'Failed To SignIn',
                                                  toastLength: Toast
                                                      .LENGTH_SHORT,);
                                                //print(_auth.error);
                                              });
                                            }
                                          }
                                        },
                                      )
                                  ),
                                  //-----------------LOGIN BUTTON---------------//

                                  SizedBox(height: 20,),
                                  FadeAnimation(1.7, Text("--OR--",
                                    style: TextStyle(color: Colors.grey),)),
                                  SizedBox(height: 20,),
                                  FadeAnimation(
                                      1.6,
                                      GradientButton(
                                          text: 'Register',
                                          onTap: () {
                                            widget.toggleView();
                                          }
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


