import 'package:flutter/material.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';
class SelectStrSem extends StatefulWidget {
  @override
  _SelectStrSemState createState() => _SelectStrSemState();
}

class _SelectStrSemState extends State<SelectStrSem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: nothingToShow(
            'We Are Currently Working On This Feature It Will Be Available Soon',
            'assets/onboarding1.png')
    );
  }
}

