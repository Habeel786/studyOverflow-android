import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/screens/wrapper.dart';
import 'package:studyoverflow/services/auth.dart';



void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFF2d3447)),
        title: 'StudyOverflow',
        home:Wrapper(),
      ),
    );
  }
}

