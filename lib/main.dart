import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/screens/wrapper.dart';
import 'package:studyoverflow/services/auth.dart';
import 'package:studyoverflow/services/database.dart';

import 'models/descmodel.dart';


void main() async{
  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //StreamProvider<CheckUpdates>(create:(_)=>DatabaseServices().checkForUpdates()),
        StreamProvider<User>(create: (_)=>AuthService().user,),
      ],
      child: MaterialApp(
        theme: new ThemeData(
          primaryColor: Color(0XFFD76EF5),
         // accentColor: Color(0XFF5173A8),
            scaffoldBackgroundColor: const Color(0xFF2d3447),
          textTheme: TextTheme(
            headline5: TextStyle(
              color: Colors.grey[700],
            ),
            caption: TextStyle(
              color: Colors.grey,
            ),
            bodyText2: TextStyle(
                color: Colors.grey[700]),
          ),
        ),
        title: 'StudyOverflow',
        home:Wrapper(),
      ),
    );
  }
}

