import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/myContribution/addNotes.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/widgets/downloadsCounter.dart';
import 'package:studyoverflow/widgets/likeDislike.dart';

class NotesTile extends StatefulWidget {
  final String title;
  final String postedBy;
  final String postedOn;
  final int like;
  final int downloads;
  final String thumbnailURL;
  final String course;
  final String semester;
  final String keys;
  bool isEdit;
  final String notesID;
  final String thumbnailID;
  final String notesURL;
  final String subject;

  NotesTile(
      {this.title,
      this.postedBy,
      this.postedOn,
      this.like,
      this.downloads,
      this.thumbnailURL,
      this.course,
      this.semester,
      this.keys,
      this.isEdit,
      this.notesID,
      this.thumbnailID,
      this.notesURL,
      this.subject});

  @override
  _NotesTileState createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('notesNode');
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseServices(uid: widget.postedBy).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          if (snapshot.hasData) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        child: widget.thumbnailURL != null
                            ? Image.network(
                                widget.thumbnailURL,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xff4776E6),
                            Color(0xff8E54E9),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            widget.isEdit
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddNotes(
                                                          uNotesID:
                                                              widget.notesID,
                                                          uNotesURL:
                                                              widget.notesURL,
                                                          uSubject:
                                                              widget.subject,
                                                          uThumbnailID: widget
                                                              .thumbnailID,
                                                          uThumbnailURL: widget
                                                              .thumbnailURL,
                                                          uTitle: widget.title,
                                                          uStream:
                                                              widget.course,
                                                          uSemester:
                                                              widget.semester,
                                                          keys: widget.keys,
                                                          uDownloads: widget.downloads,
                                                          uLikes: widget.like,
                                                        )));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                          )),
                                      InkWell(
                                          onTap: () async {
                                            bool result =
                                                await ConfirmationDialogue(context,'Delete','Delete This Notes?');
                                            if (result) {
                                              await DatabaseServices()
                                                  .deleteNotesData(
                                                      widget.thumbnailID,
                                                      widget.course,
                                                      widget.notesID,
                                                      widget.keys);
                                            }
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                          )),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Like(
                                        trigger: true,
                                        operation: 'Like',
                                        icon: Icons.thumb_up,
                                        course: widget.course,
                                        keys: widget.keys,
                                        count: widget.like,
                                        databaseReference: databaseReference,
                                        isClicked: isClicked,
                                        iconColor: Colors.black54,
                                      ),
                                      Container(
                                        width: 60,
                                        child: Text(
                                          widget.postedOn.substring(0, 19),
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.grey),
                                        ),
                                      )
                                    ],
                                  ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: !widget.isEdit,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DownloadsCounter(
                                    databaseReference: databaseReference,
                                    keys: widget.keys,
                                    course: widget.course,
                                    currentCount: widget.downloads,
                                    title: widget.title,
                                    downloadURL: widget.notesURL,
                                    pdfID: widget.notesID,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CircleAvatar(
                                        backgroundColor: Color(0xffD76EF5),
                                        child: userData.profilepic == null ||
                                                userData.profilepic == ''
                                            ? Text(
                                                getInitials(
                                                    userData.name.trimLeft()),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CachedNetworkImage(
                                                  imageUrl: userData.profilepic,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                ),
                                              )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            alignment: Alignment.bottomLeft,
                            width: 200,
                            height: 80,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.3),
                                backgroundBlendMode: BlendMode.modulate),
                            child: !widget.isEdit
                                ? RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '${widget.title}\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17)),
                                        TextSpan(
                                            text: 'By:${userData.name}',
                                            style: TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                  )
                                : RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '${widget.title}\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17)),
                                      ],
                                    ),
                                  )),
                      ),
                    ],
                  )),
            );
          } else {
            return Container();
          }
        });
  }
}
