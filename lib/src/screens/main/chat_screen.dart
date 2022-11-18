import 'dart:developer';

import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/cloud_firestore_service.dart';
import 'package:esmp_project/src/screens/chat/chat_detail_screen.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream? rooms;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _isLoading = true;
    getListRoom();
  }

  getListRoom() async {
    log(FirebaseAuth.instance.currentUser!.uid);
    await CloudFirestoreService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getRooms()
        .then((snapshot) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          rooms = snapshot;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.read<UserProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tin Nhắn',
          style: appBarTextStyle,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: (user == null)
          ? Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text('Đăng nhập'),
              ),
            )
          // : _isLoading
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
              : SingleChildScrollView(
                  // child:ListView(
                  //     scrollDirection: Axis.vertical,
                  //     shrinkWrap: true,
                  //     children:<Widget>[
                  //     ],
                  //   ),
                  child: StreamBuilder(
                    stream: rooms,
                    builder: (context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                snapshot.error!.toString(),
                                style: textStyleError,
                              ),
                            );
                          } else {
                            if (snapshot.hasData) {
                              if (snapshot.data['rooms'].length != 0) {
                                return Center(child: Text('hello'));
                              } else {
                                return noRoom();
                              }
                              // return Center(child: Text(snapshot.data['rooms'].length.toString()));
                            } else {
                              return noRoom();
                            }
                            // log(snapshot.data.toString());
                            // return noRoom();
                          }
                      }
                    },
                  ),
                ),
    );
  }

  _chatRoom() {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: InkWell(
        child: Card(
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(AppUrl.defaultAvatar),
              ),
              Text(
                "Store Name",
                style: textStyleInput,
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChatDetailScreen()));
        },
      ),
    );
  }

  noRoom() {
    return Center(
        child: Text(
          'Chưa có cuộc hội thoại',
          style: textStyleInputChild,
        ),
    );
  }
}
