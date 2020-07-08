import 'package:flutter/material.dart';
import 'package:studyoverflow/screens/authentication/newregister.dart';
import 'package:studyoverflow/screens/authentication/newsignin.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSignin=true;
  void toggleView(){
    setState(() {
      isSignin=!isSignin;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isSignin?NewSignin(toggleView: toggleView):NewRegister(toggleView: toggleView);
  }
}
