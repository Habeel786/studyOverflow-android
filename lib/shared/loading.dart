import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Color(0xFF2d3447),
      body: Container(
        child: Center(
          child: SpinKitCubeGrid(
            color: Color(0xffD76EF5),
            size: 50.0,
          ),
        ),
      ),

    );
  }
}
