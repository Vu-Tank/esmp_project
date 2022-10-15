import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/screens/chat/chat_detail_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tin Nhắn', style: textStyleInput,),
      ),
      body: SingleChildScrollView(
        child:ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              _chatRoom(),
              _chatRoom(),
              _chatRoom(),
            ],
          ),
        ),
    );
  }
  _chatRoom(){
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
              Text("Store Name", style: textStyleInput,),
            ],
          ),
        ),
        onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatDetailScreen()));
        },
      ),
    );
  }
}
