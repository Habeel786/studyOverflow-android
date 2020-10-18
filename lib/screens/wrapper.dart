import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/screens/authentication/authenticate.dart';
import 'package:studyoverflow/screens/home/MainScreen.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {


    final user = Provider.of<User>(context);
    return (user==null)?Authenticate():MainScreen();
  }
}

