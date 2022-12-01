import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/widget/widget.dart';

class ImageFullScreen extends StatelessWidget {
  const ImageFullScreen({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            // item.itemImage,
            // fit: BoxFit.cover,
            imageUrl: url,
            imageBuilder: (context, imageProvider) => Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            placeholder: (context, url) =>  Center(
              child: CircularProgressIndicator(color: mainColor),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding:  EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
