class User{
  final String uid;
//  final String name;
  final String email;
  User({this.uid,this.email});
}

class UserData{
  final String uid;
  final String stream;
  final String semester;
  final String name;
  String profilepic;

  UserData({this.uid, this.stream, this.semester, this.name, this.profilepic});
}

