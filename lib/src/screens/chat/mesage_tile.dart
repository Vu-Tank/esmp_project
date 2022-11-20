import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  const MessageTile({Key? key, required this.message, required this.sender, required this.sentByMe}) : super(key: key);
  final String message;
  final String sender;
  final bool sentByMe;
  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
          ? const EdgeInsets.only(left: 40)
          : const EdgeInsets.only(right: 40),
        padding: const EdgeInsets.only(top: 17,bottom: 17,left: 20,right: 20),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: widget.sentByMe
            ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          )
              :const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.message, textAlign: TextAlign.center,style: const TextStyle(fontSize: 16),),
            const SizedBox(height: 8.0,),
            Text('ngày gửi'),
          ],
        ),
      ),
    );
  }
}
