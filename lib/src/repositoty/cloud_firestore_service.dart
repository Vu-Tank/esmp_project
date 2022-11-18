

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CloudFirestoreService{
  final String? uid;
  CloudFirestoreService({this.uid});

  final CollectionReference userCollection=FirebaseFirestore.instance.collection("user");
  final CollectionReference roomCollection=FirebaseFirestore.instance.collection("rooms");

  Future createUserCloud()async{
    return await userCollection.doc(uid).set({
      "uid":uid,
      'rooms': []
    });
  }
  Future getRooms()async{
    return userCollection.doc(uid).snapshots();
  }
  Future createRoom({required String otherUid})async{
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    DocumentReference roomDocumentReference=await roomCollection.add({
      "createDate": formattedDate,
      'roomID': '',
      'members':[],
      'recentMessage':"",
      'recentMessageSender': "",
    });
    await roomDocumentReference.update({
      "members": FieldValue.arrayUnion(['']),
      "roomID": roomDocumentReference.id,
    });
    DocumentReference userOtherDocumentReference=userCollection.doc(otherUid);
    await userOtherDocumentReference.update({
      'rooms': FieldValue.arrayUnion(['${roomDocumentReference.id}'])
    });
    DocumentReference userDocumentReference=userCollection.doc(uid);
    return await userDocumentReference.update({
      'rooms': FieldValue.arrayUnion(['${roomDocumentReference.id}'])
    });

  }
}