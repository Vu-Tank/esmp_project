import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/models/order_detail.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackViewScreen extends StatelessWidget {
  const FeedbackViewScreen({Key? key, required this.feedbackModel}) : super(key: key);
  final FeedbackModel feedbackModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đánh giá đơn hàng',
          style: appBarTextStyle,
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 20.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RatingBarIndicator(
                  rating: feedbackModel.rate ?? 0,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 60.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  // margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Text(
                    '${feedbackModel.comment??''}\n\n\n\n\n',
                    maxLines: 5,
                    overflow: TextOverflow.fade,
                    style: textStyleInput,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                (feedbackModel.imagesFB != null && feedbackModel.imagesFB!.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Text(
                          //   '${feedback.image.length}/5',
                          //   style: (feedback.image.length == 5)
                          //       ? textStyleError
                          //       : textStyleInputChild,
                          // ),
                          SizedBox(
                            height: 200,
                            child: GridView.builder(
                                itemCount: feedbackModel.imagesFB!.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 100,
                                        width: 100,
                                        child: CachedNetworkImage(
                                          // item.itemImage,
                                          // fit: BoxFit.cover,
                                          imageUrl:
                                          feedbackModel.imagesFB![index].path!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )),
                                  );
                                }),
                          ),
                        ],
                      )
                    : Container(child: Center(child: Text('Không có hình ảnh', style: textStyleInput,),),),
                const SizedBox(height: 10.0,),
                Text(feedbackModel.createDate!.replaceAll('T', ' ').split('.')[0],style: textStyleLabel,),
                const SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
