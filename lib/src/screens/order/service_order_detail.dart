import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/cubit/ping_admin/ping_admin_cubit.dart';
import 'package:esmp_project/src/models/service_order_detail.dart';
import 'package:esmp_project/src/providers/service/service_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ServiceOrderDetailScreen extends StatefulWidget {
  const ServiceOrderDetailScreen({super.key, required this.orderId});
  final int orderId;

  @override
  State<ServiceOrderDetailScreen> createState() => _ServiceOrderDetailState();
}

class _ServiceOrderDetailState extends State<ServiceOrderDetailScreen> {
  ServiceOrderDetail? service;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalMoney = 0;
    final serviceProvider = Provider.of<ServiceProvider>(context);
    for (var element in serviceProvider.service) {
      if (element.orderID == widget.orderId) {
        service = element;
        if (service!.details!.isNotEmpty) {
          for (var element in service!.details!) {
            totalMoney = totalMoney +
                (element.pricePurchase! * (1 - element.discountPurchase!)) *
                    element.amount!;
          }
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Thông tin ${service!.serviceType!.statusName!.toLowerCase()}',
              style: appBarTextStyle),
          backgroundColor: mainColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => PingAdminCubit(),
            child: BlocConsumer<PingAdminCubit, PingAdminState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state is PingAdminSuccess) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      actions: [
                        TextButton(
                          child: Text(
                            'Thoát',
                            style: TextStyle(color: btnColor, fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                          },
                        ),
                      ],
                      title: Text(
                        'Thành công',
                        style: textStyleInput,
                      ),
                    ),
                  ).then((value) => Navigator.pop(context, 'Cancel'));
                } else if (state is PingAdminFailed) {
                  showMyAlertDialog(context, state.msg);
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trạng thái: ${service!.servicestatus!.statusName}',
                                style: textStyleInput.copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const Icon(Icons.store),
                                  Expanded(
                                      child: Text(
                                    '${service!.storeView!.storeName}\n',
                                    maxLines: 1,
                                    style:
                                        textStyleInput.copyWith(fontSize: 16),
                                  )),
                                ],
                              ),
                              const Divider(
                                color: Colors.black,
                              ),
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: service!.details!.length,
                                  itemBuilder: (ctx, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              //hinhf anh
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: CachedNetworkImage(
                                                      // item.itemImage,
                                                      // fit: BoxFit.cover,
                                                      imageUrl: service!
                                                          .details![index]
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
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              //ten
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      "${service!.details![index].sub_ItemName}\n",
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Text(
                                                      'Số lượng: ${service!.details![index].amount}'),

                                                  // tiền
                                                ],
                                              )),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const Divider(
                                            color: Colors.black,
                                          ),
                                          if (service!.serviceType!
                                                  .item_StatusID! ==
                                              2)
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Tiền hoàn',
                                                    style: TextStyle(
                                                        color: mainColor,
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                      Utils.convertPriceVND(
                                                          totalMoney),
                                                      style: const TextStyle(
                                                          fontSize: 20))
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Dự tính lấy hàng:',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: mainColor,
                                    ),
                                  ),
                                  Text(service!.pick_Time ??= 'Đang xử lí',
                                      style: const TextStyle(fontSize: 17)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Dự tính giao hàng:',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: mainColor,
                                      )),
                                  Text(service!.deliver_time ??= 'Đang xử lí',
                                      style: const TextStyle(fontSize: 17)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      service!.orderShip != null
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Mã đơn hàng',
                                            style: textStyleLabelChild.copyWith(
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            'Mã giao hàng\n',
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style: textStyleLabelChild.copyWith(
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            'Thời gian tạo đơn',
                                            style: textStyleLabelChild,
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            'Trạng thái',
                                            style: textStyleLabelChild,
                                          )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            service!.afterBuyServiceID
                                                .toString(),
                                            style: textStyleLabelChild.copyWith(
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 200),
                                            child: Text(
                                              '${service!.orderShip!.labelID.toString()}\n',
                                              style:
                                                  textStyleLabelChild.copyWith(
                                                      color: Colors.black),
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 200),
                                            child: Text(
                                              service!.orderShip!.createDate
                                                  .replaceAll('T', ' ')
                                                  .toString()
                                                  .split('.')
                                                  .toString(),
                                              style: textStyleLabelChild,
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            '${service!.orderShip!.status.toString()}\n',
                                            style: textStyleLabelChild.copyWith(
                                                color: Colors.black),
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                            onPressed: (state is PingAdminLoading)
                                ? null
                                : (service!.servicestatus!.item_StatusID == 2 ||
                                        service!.servicestatus!.item_StatusID ==
                                            3)
                                    ? () {
                                        context
                                            .read<PingAdminCubit>()
                                            .pingAdmin(
                                                token: context
                                                    .read<UserProvider>()
                                                    .user!
                                                    .token!,
                                                serviceId: service!
                                                    .afterBuyServiceID!);
                                      }
                                    : null,
                            child: (state is PingAdminLoading)
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Báo cáo hệ thống',
                                    style: textStyleInputChild,
                                  )),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
