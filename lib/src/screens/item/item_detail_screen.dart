import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/item.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/item/item_detail_provider.dart';
import 'package:esmp_project/src/providers/cart/item_provider.dart';
import 'package:esmp_project/src/providers/main_screen_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
import 'package:esmp_project/src/screens/item/sub_item_bottom_sheet.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/screens/main/main_screen.dart';
import 'package:esmp_project/src/screens/report/report_screen.dart';
import 'package:esmp_project/src/screens/shop/shop_detail.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({Key? key, required this.itemID}) : super(key: key);
  final int itemID;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late bool _isLoading;

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: ItemRepository.getItemDetail(widget.itemID),
    //     builder: (context, snapshot) {
    //       switch(snapshot.connectionState){
    //         case ConnectionState.waiting:
    //           return const Scaffold(
    //             body: Center(
    //               child: CircularProgressIndicator(),
    //             ),
    //           );
    //         default:
    //           if(snapshot.hasError){
    //             return errorScreen(context, "lỗi hệ thống");
    //           }else{
    //             if(snapshot.data!.isSuccess!){
    //               ItemDetail itemDetail = snapshot.data!.dataResponse as ItemDetail;
    //               return _itemDetail(itemDetail, context);
    //             }else{
    //               log(snapshot.data!.message!);
    //               return errorScreen(context, snapshot.data!.message!);
    //             }
    //           }
    //       }
    //
    //     });

    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _itemDetail();
  }

  _itemDetail() {
    final idProvider = Provider.of<ItemDetailProvider>(context);
    ItemDetail itemDetail = idProvider.itemDetail;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // log(itemDetail.listFeedback.toString());
    return Scaffold(
      appBar: AppBar(
        // title: Text(itemDetail.name),
        backgroundColor: mainColor,
        actions: [
          IconButton(
            onPressed: () {
              context.read<MainScreenProvider>().changePage(2);
              // Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          IconButton(
              onPressed: () {
                if (context.read<UserProvider>().user == null) {
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
                            status: 'item', id: itemDetail.itemID)));
              },
              icon: const Icon(Icons.report))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // image
            SizedBox(
              height: height * 1 / 3,
              child: PageView.builder(
                  itemCount: itemDetail.listImage.length,
                  itemBuilder: (context, index) => CachedNetworkImage(
                        // item.itemImage,
                        // fit: BoxFit.cover,
                        imageUrl: itemDetail.listImage[index].path!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
            ),
            //giá
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    ((itemDetail.maxPrice != itemDetail.minPrice)
                        ? '${Utils.convertPriceVND(itemDetail.minPrice - (itemDetail.minPrice * itemDetail.discount * 0.01))}- ${Utils.convertPriceVND(itemDetail.maxPrice - (itemDetail.maxPrice * itemDetail.discount * 0.01))}'
                        : Utils.convertPriceVND(itemDetail.minPrice -
                            (itemDetail.minPrice *
                                itemDetail.discount *
                                0.01))),
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  if (itemDetail.discount != 0)
                    Text(
                      (itemDetail.maxPrice != itemDetail.minPrice
                          ? '${Utils.convertPriceVND(itemDetail.minPrice)}-${Utils.convertPriceVND(itemDetail.maxPrice)}'
                          : Utils.convertPriceVND(itemDetail.minPrice)),
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(itemDetail.name),
                  //rating
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //rating
                      Row(
                        children: <Widget>[
                          RatingBarIndicator(
                            rating: itemDetail.rate,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                          Text(itemDetail.rate.toString()),
                        ],
                      ),
                      // đã bán
                      Text(
                        'Đã bán: ${itemDetail.numSold} ',
                        style: textStyleInputChild,
                      ),
                    ],
                  ),
                  if (itemDetail.listSubItem.length > 1)
                    InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          const Text('Lựa chọn'),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: itemDetail.listSubItem.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final subItem = itemDetail.listSubItem[index];
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: CachedNetworkImage(
                                            // item.itemImage,
                                            // fit: BoxFit.cover,
                                            imageUrl: subItem.image.path!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        Text(
                                          Utils.convertPriceVND(subItem.price -
                                              (subItem.price *
                                                  itemDetail.discount)),
                                          // style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: SubItemBottomSheet(
                              subItems: itemDetail.listSubItem,
                              status: 'add_cart',
                              title: 'Thêm vào giỏ hàng',
                            ),
                          ),
                        );
                      },
                    ),
                  const Divider(
                    color: Colors.black,
                  ),
                  //store
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(itemDetail.store.imagePath),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            itemDetail.store.storeName,
                            style: textStyleInput,
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopDetailScreen(
                                      store: itemDetail.store)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        child: Text(
                          'Xem shop',
                          style: btnTextStyle,
                        ),
                      ),
                    ],
                  ),
                  //
                  // thong so kỹ thuat
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 1,
                    endIndent: 1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Thông số kỹ thuật',
                        style: textStyleInputChild,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(
                        color: Colors.black,
                        height: 1,
                        endIndent: 1,
                      ),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: itemDetail.listSpecification.length,
                          itemBuilder: (context, index) {
                            double width = MediaQuery.of(context).size.width;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width / 2,
                                    child: Text(
                                      itemDetail.listSpecification[index]
                                          .specificationName,
                                      style: textStyleInputChild,
                                    ),
                                  ),
                                  Text(
                                    itemDetail.listSpecification[index].value,
                                    style: textStyleInputChild,
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                  // mo ta
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 1,
                    endIndent: 1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Mô tả',
                    style: textStyleInputChild,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    itemDetail.description,
                    style: textStyleInputChild,
                  ),
                  // các hãng có thể dùng
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 1,
                    endIndent: 1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Các Loại xe có thể dùng',
                    style: textStyleInputChild,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                      itemCount: itemDetail.listMotorBrand.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        final motor = itemDetail.listMotorBrand[index];
                        return ListTile(
                          title: Text(
                              '${motor.name} - ${motor.listMotor.toString()}'),
                        );
                      }),
                  const Divider(
                    color: Colors.black,
                  ),
                  // đánh giá
                  Text(
                    'Đánh giá',
                    style: textStyleInputChild,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: itemDetail.listFeedback.length + 1,
                      itemBuilder: (context, index) {
                        if (index < itemDetail.listFeedback.length) {
                          var feedback = itemDetail.listFeedback[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //avarta
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(30),
                                  child: CachedNetworkImage(
                                    // item.itemImage,
                                    // fit: BoxFit.cover,
                                    imageUrl: feedback.userAvatar,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              // name
                              Expanded(
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        //Name
                                        Text(
                                          feedback.userName,
                                          style: textStyleInputChild,
                                        ),
                                        //rating
                                        Row(
                                          children: <Widget>[
                                            RatingBarIndicator(
                                              rating: itemDetail.rate,
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              itemSize: 20.0,
                                              direction: Axis.horizontal,
                                            ),
                                            Text(itemDetail.rate.toString()),
                                          ],
                                        ),
                                        // loại item
                                        Text(
                                          feedback.subItemName,
                                          style: textStyleInputChild,
                                        ),
                                        //text
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          (feedback.comment.isEmpty)
                                              ? 'Không có mô tả'
                                              : feedback.comment,
                                          style: textStyleInputChild,
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        //ảnh
                                        (feedback.imagesFB.isNotEmpty)
                                            ? SizedBox(
                                                height: 110,
                                                width: double.infinity,
                                                child: GridView.builder(
                                                    itemCount: feedback
                                                        .imagesFB.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 1),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 100,
                                                          width: 100,
                                                          child:
                                                              CachedNetworkImage(
                                                            // item.itemImage,
                                                            // fit: BoxFit.cover,
                                                            imageUrl: feedback
                                                                .imagesFB[index]
                                                                .path!,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : Container(),
                                        // ngày tạo
                                        Text(
                                          feedback.createDate
                                              .replaceAll('T', ' ')
                                              .split('.')[0],
                                          style: textStyleLabelChild,
                                        )
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          UserModel? user =
                                              context.read<UserProvider>().user;
                                          if (user == null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen()));
                                            return;
                                          }
                                          if (user.userID == feedback.userID) {
                                            showMyAlertDialog(context,
                                                'Không thể tố cáo đánh giá của mình!');
                                            return;
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReportScreen(
                                                          status: 'feedback',
                                                          id: feedback
                                                              .orderDetailID)));
                                        },
                                        icon: const Icon(Icons.report)),
                                  ],
                                ),
                              )
                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: idProvider.hasMore
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      'Có ${itemDetail.listFeedback.length} đánh giá'),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                //print('called on tap');
              },
              child: SizedBox(
                height: kToolbarHeight,
                width: width * 1 / 2,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.chat_bubble_outline),
                    Text(
                      'Chat',
                      textAlign: TextAlign.center,
                      style: textStyleInputChild,
                    ),
                  ],
                )),
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () async {
                UserModel? user = context.read<UserProvider>().user;
                if (user == null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                } else {
                  if (itemDetail.listSubItem.length == 1) {
                    context
                        .read<ItemProvider>()
                        .selectedSubItem(itemDetail.listSubItem[0]);
                    context.read<ItemProvider>().amount = 1;
                    LoadingDialog.showLoadingDialog(context, "Vui Lòng Đợi");
                    inspect(user);
                    log(itemDetail.itemID.toString());
                    log(user.token.toString());
                    log(itemDetail.listSubItem[0].subItemID.toString());
                    ApiResponse apiResponse = await OrderRepository.createOder(
                        userID: user.userID!,
                        amount: 1,
                        subItemID: itemDetail.listSubItem[0].subItemID,
                        token: user.token!);
                    if (apiResponse.isSuccess!) {
                      if (mounted) {
                        LoadingDialog.hideLoadingDialog(context);
                        showMyAlertDialog(context, apiResponse.message!);
                      }
                    } else {
                      if (mounted) {
                        LoadingDialog.hideLoadingDialog(context);
                        inspect(apiResponse);
                        showMyAlertDialog(context, apiResponse.message!);
                      }
                    }
                  } else {
                    // _showBottomSheet(context, itemDetail.listSubItem);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: SubItemBottomSheet(
                          subItems: itemDetail.listSubItem,
                          status: 'add_cart',
                          title: 'Thêm vào giỏ hàng',
                        ),
                      ),
                    );
                    // isScrollControlled: true,
                    // builder: (_) => showSubItemAddToCart(
                    //     context: context,
                    //     subItems: itemDetail.listSubItem,
                    //     status: 'add_cart',
                    //     title: 'Thêm vào giỏ hàng',
                    //     onSuccess: () {
                    //       Navigator.pop(context);
                    //     },
                    //     onFailed: (String msg) {
                    //       LoadingDialog.hideLoadingDialog(context);
                    //       showMyAlertDialog(context, msg);
                    //     }));
                  }
                }
              },
              child: SizedBox(
                height: kToolbarHeight,
                width: width * 1 / 2,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.add_shopping_cart),
                    Text(
                      'Thêm và giỏ hàng',
                      textAlign: TextAlign.center,
                      style: textStyleInputChild,
                    ),
                  ],
                )),
              ),
            ),
          ),
          // Material(
          //   color: Colors.white,
          //   child: InkWell(
          //     onTap: () async {
          //       //print('called on tap');
          //       UserModel? user = context.read<UserProvider>().user;
          //       if (user == null) {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => LoginScreen()));
          //       } else {
          //         showModalBottomSheet(
          //             context: context,
          //             builder: (context) => SubItemBottomSheet(
          //               subItems: itemDetail.listSubItem,
          //               status: 'buy_now',
          //               titel: 'Mua Ngay',
          //             ));
          //       }
          //     },
          //     child: SizedBox(
          //       height: kToolbarHeight,
          //       width: width * 2 / 5,
          //       child: Center(
          //           child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: <Widget>[
          //           Text(
          //             'Mua ngay',
          //             textAlign: TextAlign.center,
          //             style: textStyleInputChild,
          //           ),
          //         ],
          //       )),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    final idProvider = context.read<ItemDetailProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      idProvider.initItemDetail(itemId: widget.itemID).then((value) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        showMyAlertDialog(context, error.toString());
        // Navigator.pop(context);
      });
    });
  }
}
