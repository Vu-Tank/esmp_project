import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/models/order_detail.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/feedback/rated_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/feedback/feedback_screen.dart';
import 'package:esmp_project/src/screens/feedback/feedback_view_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackedScreen extends StatefulWidget {
  const FeedbackedScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackedScreen> createState() => _FeedbackedScreenState();
}

class _FeedbackedScreenState extends State<FeedbackedScreen> {
  late bool _isLoading;
  final controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final feedbacksProvider =
        Provider.of<RatedProvider>(context, listen: false);
    UserModel user = context.read<UserProvider>().user!;
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      feedbacksProvider
          .initData(userID: user.userID!, token: user.token!)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        if(mounted)showMyAlertDialog(context, error.toString());
      });
    });
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        context.read<RatedProvider>().addData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratedProvider = Provider.of<RatedProvider>(context);
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ratedProvider.listFeedback.isEmpty
              ? Center(
                  child: Text(
                    "Không có kết quả trả về",
                    style: textStyleInput,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: ratedProvider.listFeedback.length+1,
                  controller: controller,
                  itemBuilder: (context, index) {
                    if(index<ratedProvider.listFeedback.length){
                      FeedbackModel feedbackModel =
                      ratedProvider.listFeedback[index];
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  //hinhf anh
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: CachedNetworkImage(
                                      // item.itemImage,
                                      // fit: BoxFit.cover,
                                      imageUrl: feedbackModel.subItemImage,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(8.0))),
                                          ),
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                    ),
                                  ),
                                  //ten
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("${feedbackModel.subItemName}\n",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              const Text('Ngày nhận hàng: ', style: TextStyle(color: Colors.grey),),
                                              Text(feedbackModel.deliveryDate!
                                                  .split('T')[0], style:const TextStyle(color: Colors.grey)),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          OutlinedButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FeedbackScreen(
                                                                orderDetailID:
                                                                feedbackModel
                                                                    .orderDetaiID)))
                                                    .then((value) {
                                                  if (value != null) {
                                                    if (mounted) {
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                    }
                                                    UserModel user = context
                                                        .read<UserProvider>()
                                                        .user!;
                                                    ratedProvider
                                                        .initData(
                                                        userID: user.userID!,
                                                        token: user.token!)
                                                        .then((value) {
                                                      if (mounted) {
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                      }
                                                    });
                                                  }
                                                });
                                              },
                                              child: const Text(
                                                'Đánh giá',
                                                style: TextStyle(color: Colors.black),
                                              )),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ));
                    }else{
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: ratedProvider.hasMore
                              ? const CircularProgressIndicator()
                              : Text(
                              'Có ${ratedProvider.listFeedback.length} kết quả'),
                        ),
                      );
                    }
                  }),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
}
