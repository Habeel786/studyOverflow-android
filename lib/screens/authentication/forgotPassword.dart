import 'package:fluttertoast/fluttertoast.dart';
import 'package:studyoverflow/services/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/services/auth.dart';
import 'package:studyoverflow/shared/loading.dart';

class ForgotPassword extends StatefulWidget {
  final Function toggleView;
  ForgotPassword({this.toggleView});
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formkey = GlobalKey<FormState>();
  final _auth= AuthService();
  String email= "";
  String error="";
  bool loading= false;
  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      body: Container(
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
                  FadeAnimation(1, Text("Find Your Account", style: TextStyle(color: Colors.white, fontSize: 30),)),
                  SizedBox(height: 10,),
                  FadeAnimation(1.3, Text("Enter your studyoverflow email linked to your account", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF2d3447),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
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
                                )]
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.grey),
                                    validator: (val)=>val.isEmpty?"Enter Valid Email": null,
                                    onChanged:(val){
                                      setState(() {
                                        email=val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Email",
                                        labelStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                          SizedBox(height: 40,),
                          Column(
                            children: <Widget>[
                              //-----------------BUTTON---------------//
                              FadeAnimation(1.6, GestureDetector(
                                onTap: ()async{
                                  if(_formkey.currentState.validate()) {
                                    setState(() {
                                      loading=true;
                                    });
                                    dynamic results = await _auth.forgotPassword(email);
                                    if(results==null){
                                      setState(() {
                                        loading=false;
                                      }
                                      );
                                      Fluttertoast.showToast(
                                        msg: 'reset password link sent to your email address',
                                        toastLength: Toast.LENGTH_SHORT,);
                                    }else{
                                      setState(() {
                                        loading=false;
                                        //print(_auth.error);
                                      }
                                      );
                                      Fluttertoast.showToast(
                                        msg: 'failed',
                                        toastLength: Toast.LENGTH_SHORT,);
                                    }
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                          colors: [Color(0xffD76EF5), Color(0xff8F7AFE)]
                                      )
                                  ),
                                  child: Center(
                                    child: Text("Next", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              )),
                              //-----------------BUTTON---------------//
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}