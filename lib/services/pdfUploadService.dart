import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UploadPDF {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://testapp-b0eef.appspot.com');
  StorageUploadTask uploadTask;

  startUpload(File pdf) async {
    String filePath = 'notes/${DateTime.now()}.pdf';
    uploadTask = _storage.ref().child(filePath).putFile(pdf);
    StorageTaskSnapshot storageTaskSnapshot;
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    if (snapshot.error == null) {
      storageTaskSnapshot = snapshot;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    }
  }
}
