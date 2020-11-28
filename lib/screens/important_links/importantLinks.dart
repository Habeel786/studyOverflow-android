import 'package:flutter/material.dart';
import 'package:studyoverflow/models/notificationModel.dart';
import 'package:studyoverflow/screens/important_links/linksTile.dart';
import 'package:studyoverflow/screens/notifications/notificationTile.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';
class ImpLinks extends StatefulWidget {
  @override
  _ImpLinksState createState() => _ImpLinksState();
}

class _ImpLinksState extends State<ImpLinks> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseServices().getLinks(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            ImpLinksModel model= snapshot.data;
            List links=model.links;
            return links==null?nothingToShow(
                'No current Links available',
                'assets/onboarding1.png'):
            Scaffold(
              appBar: AppBar(
                title: Text('Important Links'),
                centerTitle: true,
                backgroundColor: Color(0xFF2d3447),
              ),
              body: ListView.builder(
                  itemCount: links.length,
                  itemBuilder: (context,index){
                    return LinkTile(
                      data: links[index],
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
