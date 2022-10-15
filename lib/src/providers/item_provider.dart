import 'package:esmp_project/src/models/item.dart';
import 'package:flutter/material.dart';
class ItemProvider extends ChangeNotifier{
  final Item item;
  ItemProvider({required this.item});
}