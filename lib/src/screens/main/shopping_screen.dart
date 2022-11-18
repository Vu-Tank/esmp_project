import 'dart:developer';

import 'package:esmp_project/src/models/item.dart';
import 'package:esmp_project/src/models/search_item_model.dart';
import 'package:esmp_project/src/providers/item/items_provider.dart';
import 'package:esmp_project/src/screens/item/filtter_search.dart';
import 'package:esmp_project/src/screens/item/item_widget.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/my_search.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late bool _isLoading;
  bool _isSearch = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;
    double width = MediaQuery.of(context).size.width;
    final itemProvider = Provider.of<ItemsProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: height,
          ),
          Container(
            // height: 100,
            color: mainColor,
            child: Row(
              children: [
                (_isSearch)
                    ? IconButton(
                        onPressed: () async {
                          itemProvider.txtSearch = null;
                          itemProvider.reset();
                          LoadingDialog.showLoadingDialog(
                              context, "Vui lòng đợi");
                          await itemProvider.initItems().then((value) {
                            if (mounted) {
                              LoadingDialog.hideLoadingDialog(context);
                            }
                            _searchController.clear();
                            controller.jumpTo(0);
                            setState(() {
                              _isSearch = false;
                            });
                          }).catchError((error) {
                            LoadingDialog.hideLoadingDialog(context);
                            showMyAlertDialog(context, error.toString());
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        icon: const Icon(Icons.arrow_back))
                    : const SizedBox(
                        width: 10,
                      ),
                SizedBox(
                  height: 80,
                  width: width - ((_isSearch) ? 100 : 60),
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 8.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                        ),
                        controller: _searchController,
                        onSubmitted: (String? value) async {
                          if (itemProvider.txtSearch != null) {
                            if (_searchController.text
                                    .compareTo(itemProvider.txtSearch!) ==
                                0) {
                              return;
                            }
                          }
                          if (_searchController.text.isEmpty) {
                            return;
                          }
                          final filter = context.read<ItemsProvider>();
                          filter.reset();
                          LoadingDialog.showLoadingDialog(
                              context, "Vui lòng đợi");
                          var future = Future.wait([
                            filter.getTxtSearch(_searchController.text.trim()),
                          ]);
                          future.then((value) async {
                            LoadingDialog.hideLoadingDialog(context);
                            if (mounted) {
                              LoadingDialog.showLoadingDialog(
                                  context, "Vui lòng đợi");
                            }
                            await itemProvider
                                .applySearch()
                                .catchError((error) {
                              LoadingDialog.hideLoadingDialog(context);
                              showMyAlertDialog(context, error.toString());
                            }).whenComplete(() {
                              controller.jumpTo(0);
                              LoadingDialog.hideLoadingDialog(context);
                              setState(() {
                                _isSearch = true;
                              });
                            });
                          }).catchError((error) {
                            LoadingDialog.hideLoadingDialog(context);
                            if (error.toString().contains('TimeoutException')) {
                              showMyAlertDialog(context, error.toString());
                            }
                          });
                        },
                      ),
                      IconButton(
                          onPressed: () async {
                            if (itemProvider.txtSearch != null) {
                              if (_searchController.text
                                      .compareTo(itemProvider.txtSearch!) ==
                                  0) return;
                            }
                            if (_searchController.text.isEmpty) {
                              return;
                            }
                            final filter = context.read<ItemsProvider>();
                            filter.reset();
                            LoadingDialog.showLoadingDialog(
                                context, "Vui lòng đợi");
                            var future = Future.wait([
                              filter
                                  .getTxtSearch(_searchController.text.trim()),
                            ]);
                            future.then((value) async {
                              LoadingDialog.hideLoadingDialog(context);
                              SearchItemModel? result = filter.getSearchModel();
                              Map<String, dynamic> search = result.toJson();
                              Utils.removeNullAndEmptyParams(search);
                              if (search.isNotEmpty) {
                                if (mounted) {
                                  LoadingDialog.showLoadingDialog(
                                      context, "Vui lòng đợi");
                                }
                                await itemProvider
                                    .applySearch()
                                    .catchError((error) {
                                  LoadingDialog.hideLoadingDialog(context);
                                  showMyAlertDialog(context, error.toString());
                                }).whenComplete(() {
                                  controller.jumpTo(0);
                                  LoadingDialog.hideLoadingDialog(context);
                                  setState(() {
                                    _isSearch = true;
                                  });
                                  FocusManager.instance.primaryFocus?.unfocus();
                                });
                              }
                            }).catchError((error) {
                              LoadingDialog.hideLoadingDialog(context);
                              if (error
                                  .toString()
                                  .contains('TimeoutException')) {
                                showMyAlertDialog(context, error.toString());
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      final filter = context.read<ItemsProvider>();
                      LoadingDialog.showLoadingDialog(
                          context, "Vui lòng đợi");
                      var future = Future.wait([
                        filter.getCategory(),
                        filter.getMotorBrand(),
                        filter.initSortModel(),
                        filter.getTxtSearch(_searchController.text.trim()),
                      ]);
                      future.then((value) async {
                        LoadingDialog.hideLoadingDialog(context);
                        SearchItemModel? result = await showDialog(
                            context: context,
                            builder: (context) => const FilterSearchDialog());
                        if (result != null) {
                          Map<String, dynamic> search = result.toJson();
                          Utils.removeNullAndEmptyParams(search);
                          if (search.isNotEmpty) {
                            if (mounted) {
                              LoadingDialog.showLoadingDialog(
                                  context, "Vui lòng đợi");
                            }
                            await itemProvider
                                .applySearch()
                                .catchError((error) {
                              LoadingDialog.hideLoadingDialog(context);
                              showMyAlertDialog(context, error.toString());
                            }).whenComplete(() {
                              controller.jumpTo(0);
                              LoadingDialog.hideLoadingDialog(context);
                              setState(() {
                                _isSearch = true;
                              });
                            });
                          }
                        }
                      }).catchError((error) {
                        LoadingDialog.hideLoadingDialog(context);
                        if (error.toString().contains('TimeoutException')) {
                          showMyAlertDialog(context, error.toString());
                        }
                      });
                    },
                    icon: const Icon(Icons.filter_alt_rounded))
              ],
            ),
          ),
          _isLoading
              ? const Expanded(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : itemProvider.items.isEmpty
                  ? Center(
                      child: Text(
                        "Không có kết quả trả về",
                        style: textStyleInput,
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                          // crossAxisCount: 2,
                          // crossAxisSpacing: 10,
                          // mainAxisSpacing: 10,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 8.0 / 12.0,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          controller: controller,
                          itemCount: itemProvider.items.length + 1,
                          itemBuilder: (context, index) {
                            if (index < itemProvider.items.length) {
                              final item = itemProvider.items[index];
                              return ItemWidget(item: item);
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32),
                                child: Center(
                                  child: itemProvider.hasMore
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          'Có ${itemProvider.items.length} kết quả'),
                                ),
                              );
                            }
                          }),
                    )
        ],
      ),
    );
  }

  @override
  void initState() {
    final itemProvide = Provider.of<ItemsProvider>(context, listen: false);
    // log(itemProvide.items.length.toString());
    if (itemProvide.items.isEmpty) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        itemProvide.initItems().then((value){
          if(mounted){
            setState(() {
              _isLoading = false;
            });
          }
        });
      });
    } else {
      _isLoading = false;
    }
    if (itemProvide.txtSearch != null && itemProvide.txtSearch!.isNotEmpty) {
      _searchController.text = itemProvide.txtSearch!;
      _searchController.selection =
          TextSelection.collapsed(offset: _searchController.text.length);
    }
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        context.read<ItemsProvider>().addItem();
      }
    });
    super.initState();
  }
}
