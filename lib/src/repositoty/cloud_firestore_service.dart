import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esmp_project/src/models/room.dart';
import 'package:intl/intl.dart';

class CloudFirestoreService {
  final String? uid;

  CloudFirestoreService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");
  final CollectionReference roomCollection =
      FirebaseFirestore.instance.collection("rooms");

  Future createUserCloud(
      {required String userName, required String imageUrl}) async {
    return await userCollection.doc(uid).set(
        {"uid": uid, 'rooms': [], "userName": userName, "imageUrl": imageUrl});
  }


  // Future<Stream<List<Future<RoomChat>>>> getRoomsStream() async {
  getRoomsStream() async {
    List<String> roomsId = [];
    DocumentSnapshot user = await userCollection.doc(uid).get();
    if (user.exists) {
      log(user['userName']);
      // final data=user.data();
      if ((user['rooms'] as List).isEmpty) return null;
      for (var element in (user['rooms'] as List)) {
        roomsId.add(element.toString());
      }
      log(roomsId.toString());
    }
    final result = roomCollection
        .orderBy('time', descending: true)
        .where('roomID', whereIn: roomsId)
        .snapshots()
        .map((room) => room.docs.map((data) {
              String roomID = data['roomID'].toString();
              String createDate = data['createDate'].toString();
              String recentMessage = data['recentMessage'].toString();
              String recentMessageSender =
                  data['recentMessageSender'].toString();
              String time = data['time'].toString();
              bool isImage=data['isImage'];
              String receiverName = '';
              String receiverImageUrl = '';
              String receiverUid = '';
              if (uid == data['members']['user1'].toString()) {
                receiverUid = data['members']['user2'].toString();
              } else {
                receiverUid = data['members']['user1'].toString();
              }
              return userCollection.doc(receiverUid).snapshots().map((user) {
                if (user.exists) {
                  receiverName = user['userName'].toString();
                  receiverImageUrl = user['imageUrl'].toString();
                  receiverUid=user['uid'].toString();
                }
                return RoomChat(
                    roomID: roomID,
                    createDate: createDate,
                    time: time,
                    recentMessage: recentMessage,
                    recentMessageSender: recentMessageSender,
                    receiverName: receiverName,
                    isImage: isImage,
                    receiverImageUrl: receiverImageUrl,
                    receiverUid: receiverUid,
                );
              });
            }).toList());
    return result;
  }

  Future createRoom({required String otherUid}) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    //create room
    DocumentReference roomDocumentReference = await roomCollection.add({
      "createDate": formattedDate,
      'roomID': '',
      'members': {'user1': '', 'user2': ''},
      'recentMessage': "",
      'recentMessageSender': "",
      'isImage':false,
      'time': '0'
    });
    await roomDocumentReference.update({
      "members": {'user1': uid, 'user2': otherUid},
      "roomID": roomDocumentReference.id,
    });
    //  supllier or esmp join room
    DocumentReference userOtherDocumentReference = userCollection.doc(otherUid);
    await userOtherDocumentReference.update({
      'rooms': FieldValue.arrayUnion([(roomDocumentReference.id)])
    });
    //join room
    DocumentReference userDocumentReference = userCollection.doc(uid);
    await userDocumentReference.update({
      'rooms': FieldValue.arrayUnion([(roomDocumentReference.id)])
    });
    String receiverName='';
    String receiverImageUrl='';
    await userOtherDocumentReference.get().then((value){
      receiverName=value['userName'];
      receiverImageUrl=value['imageUrl'];
    });
    late RoomChat roomChat;
    await
    roomDocumentReference.get().then((value) {
      roomChat = RoomChat(
          roomID: value['roomID'],
          createDate: value['createDate'],
          time: value['time'],
          recentMessage: value['recentMessage'],
          recentMessageSender: value['recentMessageSender'],
          isImage:value['isImage'],
          receiverName: receiverName,
          receiverImageUrl: receiverImageUrl,
          receiverUid: otherUid,
      );
    });
    return roomChat;
  }

  Future<RoomChat?> checkExistRoom(String otherUid) async {
    log('uid: $uid');
    log('uid: $otherUid');
    QueryDocumentSnapshot? room;
    await roomCollection
        .where('members.user1', isEqualTo: uid)
        .where('members.user2', isEqualTo: otherUid)
        .get()
        .then((value) async {
      // return true;
      QuerySnapshot querySnapshot = value;
      for (var doc in querySnapshot.docs) {
        log(doc["roomID"]);
      }
      if (value.docs.length == 1) {
        room = value.docs[0];
      }
    }).catchError((e) {
      log(e.toString());
      throw Exception(e.toString());
    });
    await roomCollection
        .where('members.user2', isEqualTo: uid)
        .where('members.user1', isEqualTo: otherUid)
        .get()
        .then((value) {
      // return true;
      QuerySnapshot querySnapshot = value;
      for (var doc in querySnapshot.docs) {
        log(doc["roomID"]);
      }
      if (value.docs.length == 1) {
        room = value.docs[0];
      }
    }).catchError((e) {
      log(e.toString());
      throw Exception(e.toString());
    });
    RoomChat? roomChat;
    if (room != null) {
      String roomID = room!['roomID'];
      String createDate = room!['createDate'].toString();
      String recentMessage = room!['recentMessage'].toString();
      String recentMessageSender = room!['recentMessageSender'].toString();
      String time = room!['time'].toString();
      bool isImage=room!['isImage'];
      String receiverName = '';
      String receiverImageUrl = '';
      String receiverUid='';
      await userCollection.doc(otherUid).get().then((value) {
        if (value.exists) {
          receiverName = value['userName'];
          receiverImageUrl = value['imageUrl'];
          receiverUid=value['uid'];
          roomChat = RoomChat(
              roomID: roomID,
              createDate: createDate,
              time: time,
              recentMessage: recentMessage,
              recentMessageSender: recentMessageSender,
              receiverName: receiverName,
              receiverImageUrl: receiverImageUrl,
              receiverUid: receiverUid,
            isImage: isImage,
          );
        }
      });
    }
    return roomChat;
  }

  updateUserName(String userName) async {
    return userCollection.doc(uid).update({
      'userName': userName,
    });
  }

  updateUserImage(String imageUrl) async {
    return userCollection.doc(uid).update({
      'imageUrl': imageUrl,
    });
  }

  Future sendMessage(
      String roomId, Map<String, dynamic> chatMessageData) async {
    roomCollection.doc(roomId).collection("messages").add(chatMessageData);
    roomCollection.doc(roomId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "time": chatMessageData['time'].toString(),
      "isImage": chatMessageData['isImage'],
    });
  }

  Future getChats(String groupId) async {
    return roomCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }
}
