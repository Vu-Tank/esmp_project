import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/detail_after_service.dart';
import 'package:esmp_project/src/providers/service/service_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
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
          .then((value) => _isLoading = false)
          .catchError((error) {
        showMyAlertDialog(context, error.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    return FutureBuilder(builder: (context, snapshot) {
      final user = context.read<UserProvider>().user;
      return Scaffold(
          body: user == null
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
                  : Column(
                      children: [
                        Text(
                          'Đơn Hàng Đang Hoàn Trả',
                          style: textStyleLabel.copyWith(fontSize: 30),
                        ),
                        ListView.builder(
                            itemCount: serviceProvider.service.length + 1,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              if (index < serviceProvider.service.length) {
                                List<DetailAfterService> detail =
                                    serviceProvider.service[index].details!;
                                String status = serviceProvider
                                    .service[index].servicestatus!.statusName!;
                                return InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => OrderDetailScreen(
                                      //           order: serviceProvider.service[index].orderID,
                                      //           status: orderProvider.status.toString(),
                                      //         ))).then((value)async{
                                      //   if(value!=null){
                                      //   }
                                      // });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.builder(
                                          itemCount: detail.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
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
                                                                  borderRadius: const BorderRadius
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
                                                      height: 8.0,
                                                    ),
                                                    //ten
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                            "${detail[index].sub_ItemName}\n",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                        const SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Text(
                                                            'Số lượng: ${detail[index].amount}'),
                                                        // tiền
                                                        const SizedBox(
                                                          height: 20.0,
                                                        ),
                                                        Text(
                                                          'Trạng thái: $status',
                                                          style: TextStyle(
                                                              color: mainColor),
                                                        )
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ));
                              } else {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 32),
                                  child: Center(
                                    child: Text(
                                        'Có ${serviceProvider.service.length} kết quả'),
                                  ),
                                );
                              }
                            }),
                      ],
                    ));
    });
  }
}
