import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/screens/image_full_screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  const MessageTile({Key? key, required this.message, required this.sender, required this.sentByMe, required this.time, required this.showTime, required this.isImage}) : super(key: key);
  final String message;
  final String sender;
  final String time;
  final bool isImage;
  final bool sentByMe;
  final Function showTime;
  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool _isShowTime=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: (){
          if(widget.isImage){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageFullScreen(url: widget.message)));
          }
          setState(() {
            _isShowTime=!_isShowTime;
          });
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            widget.showTime(
              _isShowTime?20:0
            );
          });
        },
        child: Column(
          children: [
            Container(
              margin: widget.sentByMe
                ? const EdgeInsets.only(left: 40)
                : const EdgeInsets.only(right: 40),
              padding: const EdgeInsets.only(top: 17,bottom: 17,left: 20,right: 20),
              decoration: BoxDecoration(
                color: widget.sentByMe? Colors.blue: Colors.grey[200],
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
                  (widget.isImage)?
                      SizedBox(
                        height:100 ,
                        width: 100,
                        child: CachedNetworkImage(
                          // item.itemImage,
                          // fit: BoxFit.cover,
                          imageUrl: widget.message,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>  Center(
                            child: CircularProgressIndicator(color: mainColor),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      )
                  :Text(widget.message, textAlign: TextAlign.start,style: const TextStyle(fontSize: 16),),

                ],
              ),
            ),
            if(_isShowTime) Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(Utils.getTime(widget.time),style:const TextStyle(color: Colors.grey),),
            )
          ],
        ),
      ),
    );
  }
}
