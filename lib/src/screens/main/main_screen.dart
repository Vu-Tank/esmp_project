
import 'dart:developer';
import 'dart:io';

import 'package:esmp_project/src/providers/internet/connection_provider.dart';
import 'package:esmp_project/src/providers/main_screen_provider.dart';
import 'package:esmp_project/src/screens/main/account_screen.dart';
import 'package:esmp_project/src/screens/main/cart_screen.dart';
import 'package:esmp_project/src/screens/main/shopping_screen.dart';
import 'package:esmp_project/src/screens/payment_result/waiting_callback_momo.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
    return WillPopScope(child: pageUI(context), onWillPop: ()async{
      exit(0);
    });
  }

  Future<void> initDynamicLinks()async{
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri= dynamicLinkData.link;
      final queryParams=uri.queryParameters;
      if(mounted)Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WaitingCallbackMomo(queryParams: queryParams)));
    }).onError((error){
      log(error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    Provider.of<ConnectionProvider>(context, listen: false).startMonitoring();
    _pageController=PageController(
      initialPage: context.read<MainScreenProvider>().selectedPage,
    );
  }

  Widget pageUI(BuildContext context){
    return Consumer<ConnectionProvider>(builder: (context,model, child){
      if(model.isOnline!=null){
        return model.isOnline! ? mainScreen(context) : noInternet();
      }
      return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
    });
  }

  Scaffold mainScreen(BuildContext context){
    final mainPageProvider= Provider.of<MainScreenProvider>(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (newPage){
          mainPageProvider.changePage(newPage);
        },

        children: const <Widget>[
          ShoppingScreen(),
          ChatScreen(),
          CartScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1000.0,
        backgroundColor: Colors.white,
        currentIndex: mainPageProvider.selectedPage,
        onTap: (int index){
          mainPageProvider.changePage(index);
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
        },
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label:'Cửa hàng', backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label:'Tin Nhắn', backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label:'Giỏ Hàng', backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label:'Tài khoản', backgroundColor: Colors.white),
        ],
      ),
    );
  }
}
