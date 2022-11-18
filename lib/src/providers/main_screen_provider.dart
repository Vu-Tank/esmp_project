import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier{
  int selectedPage=0;
  void changePage(int index){
    selectedPage=index;
    notifyListeners();
  }
}