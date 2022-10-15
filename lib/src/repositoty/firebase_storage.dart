import 'dart:developer';
import 'dart:io';

import 'package:esmp_project/src/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file) async {
    String fileName = file.path.split('/').last;
    String exFileName=fileName.split('.').last;
    fileName='${Utils.createFile()}.$exFileName';
    try {
      Reference storageRef = storage.ref();
      Reference imagesRef = storageRef.child('images/eSMP$fileName');
      await imagesRef.putFile(file);
      String? urlDowload = await imagesRef.getDownloadURL();
      return urlDowload;
    } on FirebaseException catch (e) {
      log('Load eror: ${e.message!}');
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
      log('erro: ${e.toString()}');
      return url;
    }
  }
  Future<void> deleteFile(String fileName) async{
      Reference storageRef = storage.ref();
      Reference urlRef = storageRef.child('images').child(fileName);
      await urlRef.delete();
  }
}
