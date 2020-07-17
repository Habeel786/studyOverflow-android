import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
class UploadImage{
  Future<dynamic> uploadImage(String imageName,File diagram)async{
    print('image upload in process');
    final StorageReference strref = FirebaseStorage.instance.ref().child(imageName);
    final  StorageUploadTask task = strref.putFile(diagram);
    StorageTaskSnapshot storageTaskSnapshot;
    StorageTaskSnapshot snapshot=await task.onComplete;
    if(snapshot.error==null){
      storageTaskSnapshot = snapshot;
      String downloadUrl =await storageTaskSnapshot.ref.getDownloadURL();
      print('upload success');
      print(downloadUrl);
      return downloadUrl;
    }else{
      return null;
    }
  }
  Widget enableUpload(File image,String url){
    return InkWell(
      onLongPress: ()async{
        if(url!=null){
          await Clipboard.setData(ClipboardData(text: url));
          Fluttertoast.showToast(
            msg: 'Data Copied',
            toastLength: Toast.LENGTH_SHORT,);
        }
      },
      child: Container(
        child: Column(
          children: <Widget>[
            url==null||url==''?Image.file(image, height: 300, width: 300,):Image.network(url,height: 300, width: 300,),
          ],
        ),
      ),
    );
  }
}
