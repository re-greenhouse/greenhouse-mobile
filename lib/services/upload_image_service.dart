import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

Future<String> uploadImage(File image) async {
  final String fileName = image.path.split('/').last;

  final Reference ref = _storage.ref().child('crops').child(fileName);
  final UploadTask uploadTask = ref.putFile(image);

  final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => true);

  final String url = await taskSnapshot.ref.getDownloadURL();

  if (taskSnapshot.state == TaskState.success) {
    return url;
  } else {
    return '';
  }
}