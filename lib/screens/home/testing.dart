//import 'package:flutter/material.dart';
//import 'package:studyoverflow/database.dart';
//import 'package:studyoverflow/models/descmodel.dart';
//class Testing extends StatefulWidget {
//  @override
//  _TestingState createState() => _TestingState();
//}
//
//class _TestingState extends State<Testing> {
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder(
//      stream: DatabaseServices().getThumbnail('computer engineering', '6'),
//      builder: (context,snapshot){
//        if(snapshot.hasData){
//          SubjectThumbnail subjectThumbnail = snapshot.data;
//          List images=subjectThumbnail.thumbnail.values.toList();
//          return ListView.builder(
//            itemCount: images.length,
//              itemBuilder: (_,index){
//                return  images[index]!=null?Image.network(images[index]):Image.asset('assets/fancycolored.png');
//              });
//        }else{
//          return Container();
//        }
//      },
//    );
//  }
//}
