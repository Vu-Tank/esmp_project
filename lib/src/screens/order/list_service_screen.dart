import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/detail_after_service.dart';
import 'package:esmp_project/src/providers/service/service_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/screens/order/service_order_detail.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListServiceScreen extends StatefulWidget {
  const ListServiceScreen({super.key});

  @override
  State<ListServiceScreen> createState() => _ListServiceScreenState();
}

class _ListServiceScreenState extends State<ListServiceScreen> {
  late bool _isLoading;
  final controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    final user = context.read<UserProvider>().user;
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceProvider
          .initData(userID: user!.userID!, token: user.token!)
          .then((value) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        showMyAlertDialog(context, error.toString());
      });
    });
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        context.read<ServiceProvider>().addData();
        print("abc");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      final serviceProvider = Provider.of<ServiceProvider>(context);
      final user = context.read<UserProvider>().user;
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        user == null
            ? Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text('Đăng nhập'),
                ),
              )
            : _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: serviceProvider.service.length + 1,
                        controller: controller,
                        itemBuilder: (context, index) {
                          if (index < serviceProvider.service.length) {
                            List<DetailAfterService> detail =
                                serviceProvider.service[index].details!;
                            String status = serviceProvider
                                .service[index].servicestatus!.statusName!;
                            String orderID = serviceProvider
                                .service[index].orderID
                                .toString();
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceOrderDetailScreen(
                                                orderId: serviceProvider
                                                    .service[index].orderID!)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shadowColor: mainColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Mã đơn hàng: $orderID'),
                                            Text(
                                              'Trạng thái: $status',
                                              style:
                                                  TextStyle(color: mainColor),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ListView.builder(
                                            itemCount: detail.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  //hinhf anh
                                                  SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: CachedNetworkImage(
                                                      // item.itemImage,
                                                      // fit: BoxFit.cover,
                                                      imageUrl: detail[index]
                                                          .sub_ItemImage!,
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
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            8.0))),
                                                      ),
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 18.0,
                                                  ),
                                                  //ten
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "${detail[index].sub_ItemName}\n",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                        const SizedBox(
                                                          height: 50,
                                                        ),
                                                        Text(
                                                            'Số lượng: ${detail[index].amount}'),
                                                        // tiền
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: serviceProvider.hasMore
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        'Có ${serviceProvider.service.length} kết quả'),
                              ),
                            );
                          }
                        }),
                  ),
      ]);
    });
  }
}
