import 'package:esmp_project/src/screens/feedback/feedbacked_screen.dart';
import 'package:esmp_project/src/screens/feedback/not_yet_feedbacked_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
class ListFeedBackScreen extends StatefulWidget {
  const ListFeedBackScreen({Key? key}) : super(key: key);

  @override
  State<ListFeedBackScreen> createState() => _ListFeedBackScreenState();
}

class _ListFeedBackScreenState extends State<ListFeedBackScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            // isScrollable: true,
            tabs: [
              Tab(text: 'Chưa đánh giá',),
              Tab(text: 'Đã đánh giá'),
            ],

          ),
          title: Text('Đánh giá của tôi', style: appBarTextStyle,),
          backgroundColor: mainColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            FeedbackedScreen(),
            NotYetFeedbackedScreen(),
          ],
        ),
      ),
    );
  }
}
