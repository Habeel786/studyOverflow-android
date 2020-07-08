import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'file:///C:/Users/Smart%20computer/AndroidStudioProjects/studyoverflow/lib/services/database.dart';
import 'package:studyoverflow/models/user.dart';
class AuthService{
final FirebaseAuth _auth =FirebaseAuth.instance;
String error="";
List errors=[];
User _userFromFirebaseUser(FirebaseUser user){
return user!=null?User(uid: user.uid, email:user.email):null;
}
Future registerWithEmailAndPassword(String email, String password, String name, String semester, String stream) async{
try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user =result.user;
      await DatabaseServices(uid: user.uid).updateUserData(semester, name, stream);
      dynamic extractedUser =_userFromFirebaseUser(user);
      //print(user);
      return extractedUser;
}catch(e){
  print(e);
  error=e.toString();
  return null;
}
}
Future signInWithEmailAndPassword(String email, String password) async{
try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user =result.user;
     // print(user);
      return user;
}catch(e){
  print(e);
  String exp=e.toString();
  errors=exp.split(",");
  error=errors[1];
  print(errors[1]);

  return null;
}
}
//Logout user
  Future signOut()async{
  try{
    _auth.signOut();
  }catch(e){
    print(e.toString());
    return null;
  }
  }
Future forgotPassword(String email)async{
  try{
    _auth.sendPasswordResetEmail(email: email);
  }catch(e){
    print(e.toString());
    return null;
  }
}
Stream<User> get user{
   return _auth.onAuthStateChanged.map((FirebaseUser user)=>_userFromFirebaseUser(user));
}
}