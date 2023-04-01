import 'dart:developer';

import 'package:esmp_project/src/models/search_item_model.dart';
import 'package:esmp_project/src/models/sort_model.dart';
import 'package:esmp_project/src/providers/item/items_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/item/filtter_search.dart';
import 'package:esmp_project/src/screens/item/item_widget.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
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

  // bool _isSearch = false;

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
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: height,
          ),
          Container(
            color: mainColor,
            height: 80,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (itemProvider.isSearch && itemProvider.txtSearch != null)
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
                            if (controller.hasClients) {
                              controller.jumpTo(0);
                            }
                            itemProvider.isSearch = false;
                          }).catchError((error) {
                            log(error.toString());
                            LoadingDialog.hideLoadingDialog(context);
                            showMyAlertDialog(context, error.toString());
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        icon: const Icon(Icons.arrow_back))
                    : const SizedBox(
                        width: 10,
                      ),
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Tìm kiếm',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(40),
                            ),
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
                            final filter = itemProvider;
                            filter.reset();
                            filter.txtSearch = value;
                            LoadingDialog.showLoadingDialog(
                                context, "Vui lòng đợi");
                            await itemProvider
                                .applySearch()
                                .catchError((error) {
                              LoadingDialog.hideLoadingDialog(context);
                              showMyAlertDialog(context, error.toString());
                            }).then((_) {
                              itemProvider.isSearch = true;
                              if (controller.hasClients) {
                                controller.jumpTo(0);
                              }
                              LoadingDialog.hideLoadingDialog(context);
                            });
                            log(itemProvider.txtSearch.toString());
                          },
                        ),
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
                            final filter = itemProvider;
                            filter.reset();
                            filter.txtSearch = _searchController.text;
                            filter.selectedNewSortModel(SortModel(
                                name: "Giá giảm dần", query: 'price_asc'));
                            inspect(filter.currentAddress);
                            LoadingDialog.showLoadingDialog(
                                context, "Vui lòng đợi");
                            await itemProvider
                                .applySearch()
                                .catchError((error) {
                              LoadingDialog.hideLoadingDialog(context);
                              showMyAlertDialog(context, error.toString());
                            }).then((_) {
                              itemProvider.isSearch = true;
                              if (controller.hasClients) {
                                controller.jumpTo(0);
                              }
                              LoadingDialog.hideLoadingDialog(context);
                              FocusManager.instance.primaryFocus?.unfocus();
                            });
                            log(itemProvider.isSearch.toString());
                            inspect(itemProvider.items);
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
                      final filter = itemProvider;
                      LoadingDialog.showLoadingDialog(
                          context, "Vui lòng đợi");
                      filter.txtSearch = _searchController.text.trim();
                      var future = Future.wait([
                        filter.getCategory(),
                        filter.getMotorBrand(),
                        filter.initSortModel(),
                      ]);
                      future.then((value) async {
                        LoadingDialog.hideLoadingDialog(context);
                        SearchItemModel? result = await showDialog(
                            context: context,
                            builder: (context) => const FilterSearchDialog(
                                  status: 'view',
                                ));
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
                            }).then((_) {
                              itemProvider.isSearch = true;
                              if (controller.hasClients) {
                                controller.jumpTo(0);
                              }
                              LoadingDialog.hideLoadingDialog(context);
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
                    icon: const Icon(
                      Icons.filter_alt_rounded,
                      color: Colors.white,
                      size: 30,
                    ))
              ],
            ),
          ),
          _isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : itemProvider.items.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          "Không có kết quả trả về",
                          style: textStyleInput,
                        ),
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
                            childAspectRatio: 9 / 12,
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
                    ),
        ],
      ),
    );
  }

  @override
  void initState() {
    final itemProvide = Provider.of<ItemsProvider>(context, listen: false);
    // log(itemProvide.items.length.toString());
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemProvide.initItems().then((value) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });

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
