import 'package:flutter/material.dart';
import 'package:studyoverflow/models/notificationModel.dart';
import 'package:studyoverflow/screens/notifications/notificationTile.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';
class ShowNotifications extends StatefulWidget {
  @override
  _ShowNotificationsState createState() => _ShowNotificationsState();
}

class _ShowNotificationsState extends State<ShowNotifications> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseServices().getNotifications(),
      builder: (context, snapshot) {
       if(snapshot.hasData){
         NotificationModel model= snapshot.data;
         List nots=model.notifications;
         return nots==null?nothingToShow(
             'No current notifications available',
             'assets/onboarding1.png'):
         Scaffold(
           appBar: AppBar(
             title: Text('Notifications'),
             centerTitle: true,
             backgroundColor: Color(0xFF2d3447),
           ),
           body: ListView.builder(
               itemCount: nots.length,
               itemBuilder: (context,index){
                 return NotificationTile(
                   data: nots[index],
                 );
               }
           ),
         );
       }else{
         return Loading();
       }
      }
    );
  }
}
