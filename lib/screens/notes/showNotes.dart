import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/models/notesModel.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';
import 'package:studyoverflow/widgets/notesTile.dart';

class ShowNotes extends StatefulWidget {
  String stream;
  String semester;
  String subject;
  final String image;

  ShowNotes({this.stream, this.semester, this.subject, this.image});

  @override
  _ShowNotesState createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  var _data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = FirebaseDatabase.instance
        .reference()
        .child('notesNode')
        .child(widget.stream)
        .orderByChild('Category')
        .equalTo(widget.stream + '-' + widget.semester + '-' + widget.subject)
        .onValue;
  }

  @override
  Widget build(BuildContext context) {
    List<NotesModel> mydata = List();
    return Scaffold(
      body: StreamBuilder(
          stream: _data,
          builder: (context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              mydata.clear();
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value ?? {};
              map.forEach((k, v) {
                mydata.add(new NotesModel(
                    keys: k,
                    postedBy: v['PostedBy'] ?? '',
                    course: v['Category'].toString().split('-')[0] ?? '',
                    downloads: v['Downloads'] ?? 0,
                    like: v['Like'] ?? 0,
                    notesID: v['NotesID'],
                    notesURL: v['NotesURL'],
                    postedON: v['PostedOn'],
                    semseter: v['Category'].toString().split('-')[1] ?? '',
                    thumbnailID: v['ThumbnailID'] ?? null,
                    thumbnailURL: v['ThumbnailURL'] ?? null,
                    title: v['Title']));
              });
              return mydata.isEmpty
                  ? nothingToShow(
                      'No notes present for this subject, be the first one to contribute',
                      'assets/notfound.png')
                  : CustomScrollView(
                      primary: false,
                      slivers: <Widget>[
                        SliverAppBar(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          )),
                          centerTitle: true,
                          title: Text('Demo'),
                          pinned: true,
                          expandedHeight:
                              MediaQuery.of(context).size.height * 0.25,
                          flexibleSpace: SafeArea(
                            child: FlexibleSpaceBar(
                              background: Align(
                                  alignment: Alignment.topCenter,
                                  child: widget.image != null
                                      ? Container(
                                          height: 200,
                                          width: 200,
                                          child: CachedNetworkImage(
                                            imageUrl: widget.image,
                                            fit: BoxFit.fitHeight,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        )
                                      : Image(
                                          image: AssetImage(
                                              'assets/posterImage.png'),
                                          fit: BoxFit.cover,
                                        )),
                            ),
                          ),
                        ),
                        SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200.0,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 110 / 150,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return NotesTile(
                                    title: mydata[index].title,
                                    postedBy: mydata[index].postedBy,
                                    postedOn: mydata[index].postedON,
                                    like: mydata[index].like,
                                    downloads: mydata[index].downloads,
                                    thumbnailURL: mydata[index].thumbnailURL,
                                    course: mydata[index].course,
                                    semester: mydata[index].semseter,
                                    keys: mydata[index].keys,
                                    downloadURL: mydata[index].notesURL,
                                    isEdit: false,
                                  );
                                },
                                childCount: mydata.length,
                              ),
                            )),
                      ],
                    );
            } else {
              return Loading();
            }
          }),
    );
  }
}
