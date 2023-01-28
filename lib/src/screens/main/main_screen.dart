import 'dart:developer';
import 'dart:io';

import 'package:esmp_project/src/providers/internet/connection_provider.dart';
import 'package:esmp_project/src/providers/main_screen_provider.dart';
import 'package:esmp_project/src/screens/main/account_screen.dart';
import 'package:esmp_project/src/screens/main/cart_screen.dart';
import 'package:esmp_project/src/screens/main/shopping_screen.dart';
import 'package:esmp_project/src/screens/payment_result/waiting_callback_momo.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/widget/no_internet.dart';
import 'chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  late PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: pageUI(context),
        onWillPop: () async {
          showConfirmDialog(context, "Bạn chắc chán muốn thoát khỏi ứng dụng?")
              .then((value) {
            if (value != null) {
              if (value == 'Ok') {
                exit(0);
              }
            }
          });
          return false;
        });
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WaitingCallbackMomo(queryParams: queryParams)));
      }
    }).onError((error) {
      log(error.toString());
    });
  }

  List<Widget> visiblePageViews = const [
    ShoppingScreen(),
    ChatScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    Provider.of<ConnectionProvider>(context, listen: false).startMonitoring();
    _pageController = PageController(
      initialPage: context.read<MainScreenProvider>().selectedPage,
    );
  }

  Widget pageUI(BuildContext context) {
    return Consumer<ConnectionProvider>(builder: (context, model, child) {
      if (model.isOnline != null) {
        return model.isOnline! ? mainScreen(context) : noInternet();
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  bool isOnClick = false;
  Scaffold mainScreen(BuildContext context) {
    final mainPageProvider = Provider.of<MainScreenProvider>(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (newPage) {
          if (isOnClick) {
            setState(() {
              isOnClick = false;
            });
          } else {
            mainPageProvider.changePage(newPage);
          }
        },
        children: visiblePageViews,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1000.0,
        backgroundColor: Colors.white,
        currentIndex: mainPageProvider.selectedPage,
        onTap: (int index) async {
          mainPageProvider.changePage(index);
          // // _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
          // _pageController.jumpToPage(index);
          int pageCurrent = _pageController.page!.round();
          int pageTarget = index;
          if (pageCurrent == pageTarget) {
            return;
          }
          setState(() {
            isOnClick = true;
          });
          swapChildren(pageCurrent, pageTarget); // Step # 1
          await quickJump(pageCurrent, pageTarget); // Step # 2 and # 3
          WidgetsBinding.instance.addPostFrameCallback(refreshChildren);
        },
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Cửa hàng',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'Tin Nhắn',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Giỏ Hàng',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: 'Tài khoản',
              backgroundColor: Colors.white),
        ],
      ),
    );
  }

  void swapChildren(int pageCurrent, int pageTarget) {
    List<Widget> newVisiblePageViews = [];
    newVisiblePageViews.addAll([
      const ShoppingScreen(),
      const ChatScreen(),
      const CartScreen(),
      const AccountScreen(),
    ]);

    if (pageTarget > pageCurrent) {
      newVisiblePageViews[pageCurrent + 1] = visiblePageViews[pageTarget];
    } else if (pageTarget < pageCurrent) {
      newVisiblePageViews[pageCurrent - 1] = visiblePageViews[pageTarget];
    }

    setState(() {
      visiblePageViews = newVisiblePageViews;
    });
  }

// Step # 2 and # 3
  Future quickJump(int pageCurrent, int pageTarget) async {
    late int quickJumpTarget;

    if (pageTarget > pageCurrent) {
      quickJumpTarget = pageCurrent + 1;
    } else if (pageTarget < pageCurrent) {
      quickJumpTarget = pageCurrent - 1;
    }
    await _pageController.animateToPage(
      quickJumpTarget,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 500),
    );
    if (_pageController.hasClients) {
      _pageController.jumpToPage(pageTarget);
    }
  }

// Step # 4
  List<Widget> createPageContents() {
    return const <Widget>[
      ShoppingScreen(),
      ChatScreen(),
      CartScreen(),
      AccountScreen(),
    ];
  }

  void refreshChildren(Duration duration) {
    setState(() {
      visiblePageViews = createPageContents();
    });
  }
}
