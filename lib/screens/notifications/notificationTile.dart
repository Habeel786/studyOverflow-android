import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class NotificationTile extends StatefulWidget {
  final Map data;


  NotificationTile({this.data});

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {


    List notsData= widget.data.values.toList();
    return InkWell(
      onTap: ()async{
       if(notsData[4]!=null){
         await launch(
           notsData[4],
         );
       }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
        color: Color(0xFF2d3447),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Visibility(
                  visible: notsData[1]!="",
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: notsData[1],
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url,
                              downloadProgress) =>
                              Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Visibility(
                    visible: notsData[2]!="",
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: CachedNetworkImage(
                        imageUrl: notsData[2],
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url,
                            downloadProgress) =>
                            Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    ),
                  ),
                  title: Text(
                      notsData[3],
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17
                      ),
                    ),
                  subtitle:Text(
                      notsData[0].toString(),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15
                      ),
                    ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

