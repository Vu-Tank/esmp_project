import 'dart:developer';

import 'package:esmp_project/src/models/search_item_model.dart';
import 'package:esmp_project/src/models/store.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/shop/shop_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/cloud_firestore_service.dart';
import 'package:esmp_project/src/screens/chat/chat_detail_screen.dart';
import 'package:esmp_project/src/screens/item/filtter_search.dart';
import 'package:esmp_project/src/screens/item/item_widget.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/screens/report/report_screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({Key? key, required this.store}) : super(key: key);
  final Store store;

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late bool _isLoading;
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
    final storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
        body: WillPopScope(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: height,
          ),
          // Container(
          //   // height: 100,
          //   color: mainColor,
          //   child: Row(
          //     children: [
          //       IconButton(
          //           onPressed: () {
          //             storeProvider.reset();
          //             Navigator.pop(context);
          //           },
          //           icon:const Icon(Icons.arrow_back)),
          //       SizedBox(
          //         height: 80,
          //         width: width - 100,
          //         child: Stack(
          //           alignment: AlignmentDirectional.centerEnd,
          //           children: <Widget>[
          //             TextField(
          //               decoration: const InputDecoration(
          //                 hintText: 'Tìm kiếm',
          //                 fillColor: Colors.white,
          //                 filled: true,
          //                 contentPadding: EdgeInsets.symmetric(
          //                     vertical: 10.0, horizontal: 8.0),
          //                 border: OutlineInputBorder(
          //                     borderRadius:
          //                     BorderRadius.all(Radius.circular(5.0))),
          //               ),
          //               controller: _searchController,
          //               onSubmitted: (String? value) async {
          //                 final filter = context.read<StoreProvider>();
          //                 filter.reset();
          //                 LoadingDialog.showLoadingDialog(
          //                     context, "Vui lòng đợi");
          //                 var future = Future.wait([
          //                   filter.getTxtSearch(_searchController.text.trim()),
          //                 ]);
          //                 future.then((value) async {
          //                   LoadingDialog.hideLoadingDialog(context);
          //                   SearchItemModel? result = filter.getSearchModel();
          //                   Map<String, dynamic> search = result.toJson();
          //                   Utils.removeNullAndEmptyParams(search);
          //                   if (search.isNotEmpty) {
          //                     if (mounted) {
          //                       LoadingDialog.showLoadingDialog(
          //                           context, "Vui lòng đợi");
          //                     }
          //                     await storeProvider
          //                         .applySearch()
          //                         .catchError((error) {
          //                       LoadingDialog.hideLoadingDialog(context);
          //                       showMyAlertDialog(context, error.toString());
          //                     }).whenComplete(() {
          //                       LoadingDialog.hideLoadingDialog(context);
          //                     });
          //                   }
          //                 }).catchError((error) {
          //                   LoadingDialog.hideLoadingDialog(context);
          //                   if (error.toString().contains('TimeoutException')) {
          //                     showMyAlertDialog(context, error.toString());
          //                   }
          //                 });
          //               },
          //             ),
          //             IconButton(
          //                 onPressed: () async {
          //                   final filter = context.read<StoreProvider>();
          //                   filter.reset();
          //                   LoadingDialog.showLoadingDialog(
          //                       context, "Vui lòng đợi");
          //                   var future = Future.wait([
          //                     filter
          //                         .getTxtSearch(_searchController.text.trim()),
          //                   ]);
          //                   future.then((value) async {
          //                     LoadingDialog.hideLoadingDialog(context);
          //                     SearchItemModel? result = filter.getSearchModel();
          //                     Map<String, dynamic> search = result.toJson();
          //                     Utils.removeNullAndEmptyParams(search);
          //                     if (search.isNotEmpty) {
          //                       if (mounted) {
          //                         LoadingDialog.showLoadingDialog(
          //                             context, "Vui lòng đợi");
          //                       }
          //                       await storeProvider
          //                           .applySearch()
          //                           .catchError((error) {
          //                         LoadingDialog.hideLoadingDialog(context);
          //                         showMyAlertDialog(context, error.toString());
          //                       }).whenComplete(() {
          //                         LoadingDialog.hideLoadingDialog(context);
          //                       });
          //                     }
          //                   }).catchError((error) {
          //                     LoadingDialog.hideLoadingDialog(context);
          //                     if (error
          //                         .toString()
          //                         .contains('TimeoutException')) {
          //                       showMyAlertDialog(context, error.toString());
          //                     }
          //                   });
          //                 },
          //                 icon: const Icon(
          //                   Icons.search,
          //                   color: Colors.black,
          //                 )),
          //           ],
          //         ),
          //       ),
          //       IconButton(
          //           onPressed: () async {
          //             final filter = context.read<StoreProvider>();
          //             LoadingDialog.showLoadingDialog(
          //                 context, "Vui lòng đợi");
          //             var future = Future.wait([
          //               filter.getCategory(),
          //               filter.getMotorBrand(),
          //               filter.initSortModel(),
          //               filter.getTxtSearch(_searchController.text.trim()),
          //             ]);
          //             future.then((value) async {
          //               LoadingDialog.hideLoadingDialog(context);
          //               SearchItemModel? result = await showDialog(
          //                   context: context,
          //                   builder: (context) => const FilterSearchDialog());
          //               if (result != null) {
          //                 Map<String, dynamic> search = result.toJson();
          //                 Utils.removeNullAndEmptyParams(search);
          //                 if (search.isNotEmpty) {
          //                   if (mounted) {
          //                     LoadingDialog.showLoadingDialog(
          //                         context, "Vui lòng đợi");
          //                   }
          //                   await storeProvider
          //                       .applySearch()
          //                       .catchError((error) {
          //                     LoadingDialog.hideLoadingDialog(context);
          //                     showMyAlertDialog(context, error.toString());
          //                   }).whenComplete(() {
          //                     LoadingDialog.hideLoadingDialog(context);
          //                   });
          //                 }
          //               }
          //             }).catchError((error) {
          //               LoadingDialog.hideLoadingDialog(context);
          //               if (error.toString().contains('TimeoutException')) {
          //                 showMyAlertDialog(context, error.toString());
          //               }
          //             });
          //           },
          //           icon: const Icon(Icons.filter_alt_rounded)),
          //     ],
          //   ),
          // ),
          Container(
            color: mainColor,
            height: 70,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      if (!storeProvider.isSearch) {
                        storeProvider.reset();
                        Navigator.pop(context);
                        return;
                      }
                      storeProvider.txtSearch = null;
                      storeProvider.reset();
                      LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                      await storeProvider.applySearch().then((value) {
                        if (mounted) {
                          LoadingDialog.hideLoadingDialog(context);
                        }
                        _searchController.clear();
                        if (controller.hasClients) {
                          controller.jumpTo(0);
                        }
                        storeProvider.isSearch = false;
                      }).catchError((error) {
                        log(error.toString());
                        LoadingDialog.hideLoadingDialog(context);
                        showMyAlertDialog(context, error.toString());
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Tìm kiếm",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        controller: _searchController,
                        onSubmitted: (String? value) async {
                          if (storeProvider.txtSearch != null) {
                            if (_searchController.text
                                    .compareTo(storeProvider.txtSearch!) ==
                                0) {
                              return;
                            }
                          }
                          if (_searchController.text.isEmpty) {
                            return;
                          }
                          final filter = storeProvider;
                          filter.reset();
                          filter.txtSearch = value;
                          LoadingDialog.showLoadingDialog(
                              context, "Vui lòng đợi");
                          await storeProvider.applySearch().catchError((error) {
                            LoadingDialog.hideLoadingDialog(context);
                            showMyAlertDialog(context, error.toString());
                          }).then((_) {
                            storeProvider.isSearch = true;
                            if (controller.hasClients) {
                              controller.jumpTo(0);
                            }
                            LoadingDialog.hideLoadingDialog(context);
                          });
                        },
                      ),
                      IconButton(
                          onPressed: () async {
                            if (storeProvider.txtSearch != null) {
                              if (_searchController.text
                                      .compareTo(storeProvider.txtSearch!) ==
                                  0) return;
                            }
                            if (_searchController.text.isEmpty) {
                              return;
                            }
                            final filter = storeProvider;
                            filter.reset();
                            LoadingDialog.showLoadingDialog(
                                context, "Vui lòng đợi");
                            await storeProvider
                                .applySearch()
                                .catchError((error) {
                              LoadingDialog.hideLoadingDialog(context);
                              showMyAlertDialog(context, error.toString());
                            }).then((_) {
                              storeProvider.isSearch = true;
                              if (controller.hasClients) {
                                controller.jumpTo(0);
                              }
                              LoadingDialog.hideLoadingDialog(context);
                              FocusManager.instance.primaryFocus?.unfocus();
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
                      final filter = storeProvider;
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
                                  status: 'store',
                                ));
                        if (result != null) {
                          Map<String, dynamic> search = result.toJson();
                          Utils.removeNullAndEmptyParams(search);
                          if (search.isNotEmpty) {
                            if (mounted) {
                              LoadingDialog.showLoadingDialog(
                                  context, "Vui lòng đợi");
                            }
                            await storeProvider
                                .applySearch()
                                .catchError((error) {
                              LoadingDialog.hideLoadingDialog(context);
                              showMyAlertDialog(context, error.toString());
                            }).then((_) {
                              storeProvider.isSearch = true;
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
          // store ìnfo
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.store.imagePath),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${widget.store.storeName}\n',
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: textStyleInput,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          if (widget.store.firebaseID == null) {
                            showMyAlertDialog(
                                context, "Không thể nhắn tin với shop");
                            return;
                          }
                          await CloudFirestoreService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .checkExistRoom(
                                  widget.store.firebaseID.toString())
                              .then((value) async {
                            if (value != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatDetailScreen(roomChat: value)));
                            } else {
                              await CloudFirestoreService(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .createRoom(
                                      otherUid:
                                          widget.store.firebaseID.toString())
                                  .then((value) {
                                if (value != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatDetailScreen(
                                                  roomChat: value)));
                                }
                              }).catchError((error) {
                                showMyAlertDialog(context, error.toString());
                              });
                            }
                          }).catchError((error) {
                            log(error.toString());
                            showMyAlertDialog(context, error.toString());
                          });
                        },
                        icon: const Icon(Icons.chat_outlined)),
                    IconButton(
                        onPressed: () {
                          UserModel? user = context.read<UserProvider>().user;
                          if (user == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReportScreen(
                                      status: 'store',
                                      id: widget.store.storeID)));
                        },
                        icon: const Icon(Icons.report))
                  ],
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          _isLoading
              ? const Expanded(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : storeProvider.items.isEmpty
                  ? Center(
                      child: Text(
                        "Không có kết quả trả về",
                        style: textStyleInput,
                      ),
                    )
                  // : MasonryGridView.count(
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
                          itemCount: storeProvider.items.length + 1,
                          itemBuilder: (context, index) {
                            if (index < storeProvider.items.length) {
                              final item = storeProvider.items[index];
                              return ItemWidget(item: item);
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32),
                                child: Center(
                                  child: storeProvider.hasMore
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          'Có ${storeProvider.items.length} kết quả'),
                                ),
                              );
                            }
                          }),
                    )
        ],
      ),
      onWillPop: () async {
        storeProvider.reset();
        return true;
      },
    ));
  }

  @override
  void initState() {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    if (storeProvider.storeID != widget.store.storeID) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future future = Future.wait([
          storeProvider.getStoreID(widget.store.storeID),
          storeProvider.applySearch(),
        ]);
        future.then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } else {
      _isLoading = false;
    }
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        context.read<StoreProvider>().addItemSearch();
      }
    });
    super.initState();
  }
}
