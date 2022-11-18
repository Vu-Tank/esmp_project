import 'dart:developer';
import 'dart:io';

import 'package:esmp_project/src/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file, String fileName) async {
    try {
      Reference storageRef = storage.ref();
      Reference imagesRef = storageRef.child('images/$fileName');
      await imagesRef.putFile(file);
      String? urlDowload = await imagesRef.getDownloadURL();
      return urlDowload;
    } on FirebaseException catch (e) {
      log('Load error: ${e.message!}');
      return null;
    }
  }

  Future<String?> loadFile(String? fileName) async {
    String? url;
    try {
      if (fileName == null) {
        return url;
      } else {
        Reference storageRef = storage.ref();
        Reference urlRef = storageRef.child('images').child(fileName);
        url = await urlRef.getDownloadURL();
        return url;
      }
    } catch (e) {
      log('error: ${e.toString()}');
      return url;
    }
  }
  Future<void> deleteFile(String fileName) async{
      Reference storageRef = storage.ref();
      Reference urlRef = storageRef.child('images').child(fileName);
      await urlRef.delete();
  }
}
