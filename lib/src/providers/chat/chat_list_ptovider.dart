import 'dart:developer';

import 'package:esmp_project/src/repositoty/cloud_firestore_service.dart';
import 'package:flutter/material.dart';

import '../../models/room.dart';

class ChatListProvider extends ChangeNotifier{
  List<RoomChat> _rooms=[];

  List<RoomChat> get rooms => _rooms;
  Future<void> initRoom(String? uid)async{
    await CloudFirestoreService(uid: uid).getListRoom().then((value){
      _rooms=value as List<RoomChat>;
      notifyListeners();
    }).catchError((e){
      log(e.toString());
      throw Exception(e.toString());
    });
  }
}