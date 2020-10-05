import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/screens/wrapper.dart';
import 'package:studyoverflow/services/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
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

