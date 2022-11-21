import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/room.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/cloud_firestore_service.dart';
import 'package:esmp_project/src/screens/chat/chat_detail_screen.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat/chat_list_ptovider.dart';

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
    _isLoading = true;
    UserModel? user = context.read<UserProvider>().user;
    if (user != null) {
      final chatProvider = context.read<ChatListProvider>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // chatProvider
        //     .initRoom(FirebaseAuth.instance.currentUser!.uid)
        //     .then((value) {
        //   setState(() {
        //     _isLoading = false;
        //   });
        // }).catchError((e) {
        //   if (mounted) {
        //     setState(() {
        //       _isLoading = false;
        //     });
        //     showMyAlertDialog(context, e.toString());
        //   }
        // });
        CloudFirestoreService(uid: FirebaseAuth.instance.currentUser!.uid)
            .getRoomsStream()
            .then((value) {
          if(mounted){
            setState(() {
              _isLoading = false;
              rooms = value;
            });
          }
        }).catchError((e) {
          log(e.toString());
        });
      });
      //  getListRoom();
    }
  }

  getListRoom() async {
    log("message");
    await CloudFirestoreService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getRoomsStream()
        .then((value) {
      setState(() {
        _isLoading = false;
        rooms = value;
        log("message");
      });
    }).catchError((e) {
      log(e.toString());
    });
    log("end");
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.read<UserProvider>().user;
    final chatProvider = Provider.of<ChatListProvider>(context);
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
          : _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
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
                            if (snapshot.data != null) {
                              List<Stream<RoomChat>> listRoom =
                                  snapshot.data as List<Stream<RoomChat>>;
                              return ListView.builder(
                                itemCount: listRoom.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < listRoom.length) {
                                    return StreamBuilder(
                                        stream: listRoom[index],
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            default:
                                              if (snapshot.hasError) {
                                                return Text(
                                                  snapshot.error.toString(),
                                                  style: textStyleError,
                                                );
                                              } else {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data != null) {
                                                    final room = snapshot.data!;
                                                    return _chatRoom(room);
                                                  } else {
                                                    return Text(
                                                      'Không thể tải romchat này',
                                                      style: textStyleError,
                                                    );
                                                  }
                                                } else {
                                                  return Text(
                                                    'Không thể tải romchat này',
                                                    style: textStyleError,
                                                  );
                                                }
                                              }
                                          }
                                        });
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 32),
                                      child: Center(
                                        child: Text(
                                            'Có ${listRoom.length} kết quả'),
                                      ),
                                    );
                                  }
                                },
                              );
                            } else {
                              log('null');
                              return noRoom();
                            }
                            // return Center(child: Text(snapshot.data['rooms'].length.toString()));
                          } else {
                            log('nodata');
                            return noRoom();
                          }
                          // log(snapshot.data.toString());
                          // return noRoom();
                        }
                    }
                  },
                ),
      // chatProvider.rooms.isEmpty
      //     ? noRoom()
      //     : ListView.builder(
      //         itemCount: chatProvider.rooms.length + 1,
      //         scrollDirection: Axis.vertical,
      //         shrinkWrap: true,
      //         itemBuilder: (context, index) {
      //           if (index < chatProvider.rooms.length) {
      //             final room = chatProvider.rooms[index];
      //             return _chatRoom(room);
      //           } else {
      //             return Padding(
      //               padding: const EdgeInsets.symmetric(vertical: 32),
      //               child: Center(
      //                 child: (false)
      //                     ? const CircularProgressIndicator()
      //                     : Text(
      //                         'Có ${chatProvider.rooms.length} kết quả'),
      //               ),
      //             );
      //           }
      //         }),
    );
  }

  _chatRoom(RoomChat roomChat) {
    // return SizedBox(
    //   width: double.infinity,
    //   height: 70,
    //   child: InkWell(
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(30),
                  child: CachedNetworkImage(
                    // item.itemImage,
                    // fit: BoxFit.cover,
                    imageUrl: roomChat.receiverImageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      roomChat.receiverName,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: textStyleInput,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${(roomChat.recentMessageSender==FirebaseAuth.instance.currentUser!.uid)?'Bạn: ':''}${roomChat.recentMessage}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textStyleLabel,
                          ),
                        ),
                        Text(Utils.getTime(roomChat.time)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                      roomChat: roomChat,
                    )));
      },
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
