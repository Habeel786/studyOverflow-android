import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class LinkTile extends StatefulWidget {
  final Map data;


  LinkTile({this.data});

  @override
  _LinkTileState createState() => _LinkTileState();
}

class _LinkTileState extends State<LinkTile> {
  @override
  Widget build(BuildContext context) {


    List notsData= widget.data.values.toList();
    return InkWell(
      onTap: ()async {
        await launch(notsData[1]);
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
                  visible: notsData[0]!="",
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: notsData[0],
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
                  title: Text(
                    notsData[2],
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17
                    ),
                  ),
                  subtitle:Text(
                    notsData[1].toString(),
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

