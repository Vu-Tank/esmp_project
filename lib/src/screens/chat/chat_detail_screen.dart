import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esmp_project/src/models/room.dart';
import 'package:esmp_project/src/repositoty/cloud_firestore_service.dart';
import 'package:esmp_project/src/repositoty/firebase_storage.dart';
import 'package:esmp_project/src/screens/chat/mesage_tile.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/show_modal_bottom_sheet_image.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({Key? key, required this.roomChat}) : super(key: key);
  final RoomChat roomChat;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  Stream<QuerySnapshot>? chats;
  final ScrollController _controller = ScrollController();
  File? imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChat();
  }

  getChat() async {
    await CloudFirestoreService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getChats(widget.roomChat.roomID)
        .then((value) {
      if (mounted) {
        setState(() {
          chats = value;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RoomChat roomChat = widget.roomChat;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          roomChat.receiverName,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: appBarTextStyle,
        ),
        backgroundColor: mainColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: chatMessage(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width,
              // color: mainColor,
              child: Row(children: [
                GestureDetector(
                  onTap: () async {
                    imageFile = await showModalBottomSheetImage(context)
                        .catchError((e) {
                      showMyAlertDialog(context, e.toString());
                    });
                    if (mounted) {
                      LoadingDialog.showLoadingDialog(context, 'Đang tải ảnh');
                    }
                    if (imageFile != null) {
                      String fileName =
                          '${roomChat.roomID}_${Utils.createFile()}';
                      String? filePath = await FirebaseStorageService()
                          .uploadFileChat(imageFile!, fileName)
                          .catchError((e) {
                        if (mounted) {
                          LoadingDialog.hideLoadingDialog(context);
                          showMyAlertDialog(context, e.toString());
                        }
                      });
                      if (filePath != null) {
                        await sendImage(filePath);
                      }
                      if (mounted) LoadingDialog.hideLoadingDialog(context);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.image_outlined,
                      color: Colors.white,
                    )),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: TextField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.black),
                  onSubmitted: (_) {
                    sendMessage();
                  },
                  decoration: const InputDecoration(
                    hintText: "nhắn tin",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  chatMessage() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_controller.hasClients) {
                _controller.jumpTo(_controller.position.maxScrollExtent);
              }
            });
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              padding: const EdgeInsets.only(top: 10),
              controller: _controller,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: snapshot.data.docs[index]['message'],
                  sender: snapshot.data.docs[index]['sender'],
                  time: snapshot.data.docs[index]['time'],
                  isImage: snapshot.data.docs[index]['isImage'],
                  sentByMe: FirebaseAuth.instance.currentUser!.uid ==
                      snapshot.data.docs[index]['sender'],
                  showTime: (
                    int height,
                  ) {
                    if (_controller.hasClients) {
                      _controller.jumpTo(_controller.offset + height);
                    }
                  },
                );
              },
            );
          } else {
            return Container();
          }
        });
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": FirebaseAuth.instance.currentUser!.uid,
        "time": formattedDate,
        "isImage": false,
      };
      await CloudFirestoreService(uid: FirebaseAuth.instance.currentUser!.uid)
          .sendMessage(widget.roomChat.roomID, chatMessageMap)
          .then((value) {
        if (mounted) {
          setState(() {
            messageController.clear();
          });
        }
      }).catchError((e) {
        if (mounted) {
          showMyAlertDialog(context, e.toString());
        }
      });
    }
  }

  sendImage(String filePath) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    Map<String, dynamic> chatMessageMap = {
      "message": filePath,
      "sender": FirebaseAuth.instance.currentUser!.uid,
      "time": formattedDate,
      "isImage": true,
    };
    await CloudFirestoreService(uid: FirebaseAuth.instance.currentUser!.uid)
        .sendMessage(widget.roomChat.roomID, chatMessageMap)
        .then((value) {
      imageFile = null;
    }).catchError((e) {
      if (mounted) {
        showMyAlertDialog(context, e.toString());
      }
    });
  }
}
