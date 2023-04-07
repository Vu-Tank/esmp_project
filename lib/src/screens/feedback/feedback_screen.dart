import 'dart:io';

import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/providers/feedback/feedback_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/show_modal_bottom_sheet_image.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key, required this.orderDetailID})
      : super(key: key);
  final int orderDetailID;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 20.0),
          child: Consumer<FeedbackProvider>(
            builder: (context, feedback, __) {
              // double width = MediaQuery.of(context).size.width;
              return SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RatingBar.builder(
                        itemCount: 5,
                        initialRating: feedback.rating.toDouble(),
                        itemSize: 60.0,
                        direction: Axis.horizontal,
                        itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                        onRatingUpdate: (rating) {
                          feedback.updateRating(rating.toInt());
                        }),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                        controller: _controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        maxLength: 500,
                        decoration: const InputDecoration(
                            label: Text('lời nhắn'),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ))),
                    const SizedBox(
                      height: 20.0,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        if (feedback.image.length >= 5) {
                          showMyAlertDialog(context, "Chọn tối đa 5 bức hình");
                        } else {
                          File? result =
                              await showModalBottomSheetImage(context);
                          if (result != null) {
                            feedback.addImage(result);
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: btnColor,
                      ),
                      child: Text(
                        'Thêm ảnh',
                        style: btnTextStyle,
                      ),
                    ),
                    (feedback.image.isNotEmpty)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${feedback.image.length}/5',
                                style: (feedback.image.length == 5)
                                    ? textStyleError
                                    : textStyleInputChild,
                              ),
                              SizedBox(
                                height: 200,
                                child: GridView.builder(
                                    itemCount: feedback.image.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1),
                                    itemBuilder: (context, index) {
                                      File file = feedback.image[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            children: [
                                              Image.file(file),
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.grey,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    feedback.deleteImage(index);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(
                      height: 40.0,
                    ),
                    SizedBox(
                      height: 53,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Navigator.pop(context,'OK');
                          LoadingDialog.showLoadingDialog(
                              context, "Vui lòng đợi");
                          await feedback.upLoadFeedback(
                              token: context.read<UserProvider>().user!.token!,
                              text: _controller.text.trim(),
                              onSuccess: (FeedbackModel feedbackModel) {
                                LoadingDialog.hideLoadingDialog(context);
                                Navigator.pop(context, feedbackModel);
                              },
                              onFailed: (String msg) {
                                LoadingDialog.hideLoadingDialog(context);
                                showMyAlertDialog(context, msg);
                              },
                              orderDetailID: widget.orderDetailID);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        child: Text(
                          'Xác nhận',
                          style: btnTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
