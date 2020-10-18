import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/services/database.dart';

class Like extends StatefulWidget {
  final String course;
  final String keys;
  final int count;
  bool isClicked;
  IconData icon;
  String operation;
  DatabaseReference databaseReference;
  bool trigger;
  Color iconColor;

  Like(
      {this.course,
      this.keys,
      this.isClicked,
      this.count,
      this.icon,
      this.operation,
      this.databaseReference,
      this.trigger,
      this.iconColor});

  @override
  _LikeState createState() => _LikeState();
}

class _LikeState extends State<Like> {
  increment(int count, bool operation) {
    operation
        ? DatabaseServices().updateLikes(
            count + 1, widget.keys, widget.course, widget.databaseReference)
        : DatabaseServices().updateDisLikes(
            count + 1, widget.keys, widget.course, widget.databaseReference);
  }

  decrement(int count, bool operation) {
    operation
        ? DatabaseServices().updateLikes(
            count - 1, widget.keys, widget.course, widget.databaseReference)
        : DatabaseServices().updateDisLikes(
            count - 1, widget.keys, widget.course, widget.databaseReference);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.databaseReference
          .child(widget.course)
          .child(widget.keys)
          .child(widget.operation)
          .onValue,
      builder: (context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  //setLike();
                  widget.isClicked == false
                      ? increment(widget.count, widget.trigger)
                      : decrement(widget.count, widget.trigger);
                  setState(() {
                    widget.isClicked = !widget.isClicked;
                  });
                },
                child: Icon(
                  widget.icon,
                  color: widget.isClicked ? Colors.blue : Colors.grey,
                ),
              ),
              Text(
                widget.count.toString(),
                style: TextStyle(color: widget.iconColor??Colors.blue),
              )
            ],
          );
        } else {
          int count = snapshot.data.snapshot.value;
          return Column(
            children: [
              InkWell(
                onTap: () {
                  //setLike();
                  widget.isClicked == false
                      ? increment(count, widget.trigger)
                      : decrement(count, widget.trigger);
                  setState(() {
                    widget.isClicked = !widget.isClicked;
                  });
                },
                child: Icon(
                  widget.icon,
                  color: widget.isClicked ? Colors.blue : widget.iconColor??Colors.grey,
                ),
              ),
              Text(
                count.toString(),
                style: TextStyle(color: widget.iconColor??Colors.blue),
              )
            ],
          );
        }
      },
    );
  }
}
