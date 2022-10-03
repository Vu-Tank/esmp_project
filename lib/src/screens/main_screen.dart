import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/connection_provider.dart';
import 'package:esmp_project/src/screens/account_screen.dart';
import 'package:esmp_project/src/screens/cart_screen.dart';
import 'package:esmp_project/src/screens/chat_screen.dart';
import 'package:esmp_project/src/screens/shopping_screen.dart';
import 'package:esmp_project/src/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/widget/no_internet.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex=0;
  late PageController _pageController;
  @override
  Widget build(BuildContext context) {

    return pageUI(context);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectionProvider>(context, listen: false).startMonitoring();
    _pageController=PageController(
      initialPage: _selectedIndex,
    );
  }

  Widget pageUI(BuildContext context){
    return Consumer<ConnectionProvider>(builder: (context,model, child){
      if(model.isOnline!=null){
        return model.isOnline! ? mainScreen() : noInternet();
      }
      return Container(child: Center(child: CircularProgressIndicator(),),);
    });
  }

  Scaffold mainScreen(){
    return Scaffold(
      body: pageView(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget pageView(){
    return PageView(
      controller: _pageController,
      onPageChanged: (newPage){
        setState(() {
          _selectedIndex=newPage;
        });
      },
      children: <Widget>[
        ShoppingScreen(),
        ChatScreen(),
        CartScreen(),
        AccountScreen(),
      ],
    );
  }
  BottomNavigationBar bottomNavigationBar(){
    return BottomNavigationBar(
      elevation: 1000.0,
      backgroundColor: Colors.white,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label:'Cửa hàng', backgroundColor: Colors.white),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label:'Tin Nhắn', backgroundColor: Colors.white),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label:'Giỏ Hàng', backgroundColor: Colors.white),
        BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label:'Tài khoản', backgroundColor: Colors.white),
      ],
    );
  }
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}
