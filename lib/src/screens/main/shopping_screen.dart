import 'dart:developer';

import 'package:esmp_project/src/models/item.dart';
import 'package:esmp_project/src/providers/items_provider.dart';
import 'package:esmp_project/src/screens/item/item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: itemProvider.items.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : MasonryGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              itemCount: itemProvider.items.length,
              itemBuilder: (context, index) =>
                  ItemWidget(item: itemProvider.items[index]),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<ItemsProvider>(context,listen: false).initItems();
    });
  }
}
