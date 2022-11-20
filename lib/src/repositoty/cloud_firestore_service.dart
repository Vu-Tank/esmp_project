import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esmp_project/src/models/room.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future getRooms() async {
    return userCollection.doc(uid).snapshots();
  }

  Future<Stream<List<Future<RoomChat>>>> getRoomsStream() async {
    List<String> roomsId = [];
    DocumentSnapshot user = await userCollection.doc(uid).get();
    if (user.exists) {
      // final data=user.data();
      for (var element in (user['rooms'] as List)) {
        roomsId.add(element.toString());
      }
    }
    log(roomsId.toString());
    log(user['userName']);
    // roomCollection
    //     .where('roomID', whereIn: roomsId)
    //     .snapshots()
    //     .forEach((element) {
    //   element.docs.forEach((data) async {
    //     String roomID = data['roomID'].toString();
    //     String createDate = data['createDate'].toString();
    //     String recentMessage = data['recentMessage'].toString();
    //     String recentMessageSender =
    //     data['recentMessageSender'].toString();
    //     String time = data['time'].toString();
    //     String receiverUid = '';
    //     if (uid == data['members']['user1'].toString()) {
    //       receiverUid = data['members']['user2'].toString();
    //     } else {
    //       receiverUid = data['members']['user1'].toString();
    //     }
    //     await userCollection.doc(receiverUid).get().then((value) {
    //       if (value.exists) {
    //         String receiverName = value['userName'].toString();
    //         String receiverImageUrl = value['imageUrl'].toString();
    //           final ro=RoomChat(
    //             roomID: roomID,
    //             createDate: createDate,
    //             time: time,
    //             recentMessage: recentMessage,
    //             recentMessageSender: recentMessageSender,
    //             receiverName: receiverName,
    //             receiverImageUrl: receiverImageUrl);
    //           log(ro.toString());
    //       }
    //     });
    //   });
    // });
    final result= roomCollection
        .where('roomID', whereIn: roomsId)
        .snapshots()
        .map((room) => room.docs.map((data) async {
              String roomID = data['roomID'].toString();
              String createDate = data['createDate'].toString();
              String recentMessage = data['recentMessage'].toString();
              String recentMessageSender =
                  data['recentMessageSender'].toString();
              String time = data['time'].toString();
              String receiverName = '';
              String receiverImageUrl='';
              String receiverUid = '';
              if (uid == data['members']['user1'].toString()) {
                receiverUid = data['members']['user2'].toString();
              } else {
                receiverUid = data['members']['user1'].toString();
              }
              await userCollection.doc(receiverUid).get().then((value) {
                if (value.exists) {
                   receiverName = value['userName'].toString();
                   receiverImageUrl = value['imageUrl'].toString();
                }
              });
              return RoomChat(
                  roomID: roomID,
                  createDate: createDate,
                  time: time,
                  recentMessage: recentMessage,
                  recentMessageSender: recentMessageSender,
                  receiverName: receiverName,
                  receiverImageUrl: receiverImageUrl);
            }).toList());
    return result;
  }

  Future getListRoom() async {
    List<RoomChat> list = [];
    DocumentSnapshot? data =
        await userCollection.doc(uid).get().catchError((e) {
      log(e.toString());
      throw Exception(e.toString());
    });
    if (data.exists) {
      if (data.exists) {
        List<dynamic> rooms = data['rooms'] as List<dynamic>;
        for (var roomID in rooms) {
          DocumentSnapshot? room =
              await roomCollection.doc(roomID.toString()).get().catchError((e) {
            throw Exception(e.toString());
          });
          if (room.exists) {
            RoomChat roomChat = RoomChat(
                roomID: roomID.toString(),
                createDate: room['createDate'].toString(),
                time: room['time'].toString(),
                recentMessage: room['recentMessage'].toString(),
                recentMessageSender: room['recentMessageSender'].toString(),
                receiverName: '',
                receiverImageUrl: '');
            String receiverUid = '';
            if (uid == room['members']['user1'].toString()) {
              receiverUid = room['members']['user2'].toString();
            } else {
              receiverUid = room['members']['user1'].toString();
            }
            await userCollection.doc(receiverUid).get().then((value) {
              if (value.exists) {
                roomChat.receiverName = value['userName'].toString();
                roomChat.receiverImageUrl = value['imageUrl'].toString();
              }
              list.add(roomChat);
            }).catchError((e) {
              log(e.toString());
              throw Exception(e.toString());
            });
          }
        }
      }
    }
    return list;
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
      'time': formattedDate
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
    return await userDocumentReference.update({
      'rooms': FieldValue.arrayUnion([(roomDocumentReference.id)])
    });
  }

  Future<bool> checkExistRoom(String otherUid) async {
    bool result = false;
    log('uid: $uid');
    log('uid: $otherUid');
    await roomCollection
        .where('members.user1', isEqualTo: uid)
        .where('members.user2', isEqualTo: otherUid)
        .get()
        .then((value) {
      // return true;
      QuerySnapshot querySnapshot = value;
      for (var doc in querySnapshot.docs) {
        log(doc["roomID"]);
      }
      if (value.docs.length == 1) {
        result = true;
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
        result = true;
      }
    }).catchError((e) {
      log(e.toString());
      throw Exception(e.toString());
    });
    return result;
  }

  Future sendMessage(
      String roomId, Map<String, dynamic> chatMessageData) async {
    roomCollection.doc(roomId).collection("messages").add(chatMessageData);
    roomCollection.doc(roomId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "time": chatMessageData['time'].toString(),
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
