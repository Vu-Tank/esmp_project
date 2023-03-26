import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/cubit/ServiceTypeCubit/cubit/service_type_cubit.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/models/order_detail.dart';
import 'package:esmp_project/src/models/service_detail.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/firebase_storage.dart';
import 'package:esmp_project/src/repositoty/service_repository.dart';
import 'package:esmp_project/src/screens/main/main_screen.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

class ReturnAndExchangeScreen extends StatefulWidget {
  const ReturnAndExchangeScreen(
      {super.key, required this.orderDetail, required this.order});
  final List<OrderDetail> orderDetail;
  final Order order;
  @override
  State<ReturnAndExchangeScreen> createState() =>
      _ReturnAndExchangeScreenState();
}

class _ReturnAndExchangeScreenState extends State<ReturnAndExchangeScreen> {
  Uint8List? thumbByte;
  List<Uint8List> listPick = <Uint8List>[];
  List<ServiceDetail> list = <ServiceDetail>[];
  List<String> list2 = <String>[];
  XFile? xFile;
  MediaInfo? video;
  List<MediaInfo> listVideo = <MediaInfo>[];
  List<String> text = <String>[];
  @override
  Widget build(BuildContext context) {
    double totalMoney = 0;

    const List<String> serviceType = <String>[
      'Trả hàng và Hoàn tiền',
      'Đổi Hàng'
    ];
    TextEditingController controller = TextEditingController();
    FocusNode focus = FocusNode();
    final now = DateTime.now();
    final user = context.read<UserProvider>().user;
    String reason = '';
    for (var element in widget.orderDetail) {
      totalMoney = (totalMoney +
          (element.pricePurchase * (1 - element.discountPurchase)));
    }
    Future<ApiResponse> getdata() => ServiceRepository.createReturnSevice(
        token: user!.token!,
        orderId: widget.order.orderID,
        addressId: user.address![0].addressID!,
        serviceType: 2,
        create_Date: now.toString(),
        packingLinkCus: list2,
        list_ServiceDetail: list,
        reason: text);

    return BlocProvider(
        create: (context) => ServiceTypeCubit(),
        child: Scaffold(
            appBar: AppBar(
              title: Text('Yêu cầu trả hàng/Hoàn tiền',
                  style: appBarTextStyle),
              backgroundColor: mainColor,
            ),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: SizedBox(
                        height: 2000,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: widget.orderDetail.length,
                                itemBuilder: (context, index) {
                                  OrderDetail detail =
                                      widget.orderDetail[index];
                                  ServiceDetail ser = ServiceDetail(
                                      detailID: detail.orderDetailID,
                                      amount: detail.amount);
                                  if (list.contains(ser)) {
                                  } else {
                                    list.add(ser);
                                  }
                                  inspect(list);
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      //hinhf anh
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: CachedNetworkImage(
                                          // item.itemImage,
                                          // fit: BoxFit.cover,
                                          imageUrl: detail.subItemImage,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8.0))),
                                          ),
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      //ten
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text("${detail.subItemName}\n",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text('Số lượng: ${detail.amount}'),
                                          // tiền
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                widget.order.orderShip!.status
                                                    .toString(),
                                                style:
                                                    TextStyle(color: mainColor),
                                              ),
                                              const Spacer(),
                                              detail.discountPurchase != 0
                                                  ? Text.rich(
                                                      TextSpan(children: <
                                                          TextSpan>[
                                                      TextSpan(
                                                        text: Utils
                                                            .convertPriceVND(detail
                                                                .pricePurchase),
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                      const TextSpan(text: "-"),
                                                      TextSpan(
                                                        text: Utils.convertPriceVND(
                                                            detail.pricePurchase *
                                                                (1 -
                                                                    detail
                                                                        .discountPurchase)),
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ]))
                                                  : Text(
                                                      Utils.convertPriceVND(
                                                          detail.pricePurchase),
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      )),
                                    ],
                                  );
                                },
                              ),
                              Divider(
                                color: Colors.grey.withOpacity(0.3),
                                thickness: 10,
                              ),
                              Row(
                                children: [
                                  const Text('Phương án'),
                                  const Spacer(),
                                  BlocBuilder<ServiceTypeCubit,
                                      ServiceTypeState>(
                                    builder: (context, state) {
                                      return DropdownButton(
                                        value: state.serviceType,
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                        elevation: 10,
                                        style: TextStyle(color: mainColor),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                        onChanged: (String? value) {
                                          BlocProvider.of<ServiceTypeCubit>(
                                                  context)
                                              .changServiceType(value!);
                                        },
                                        items: serviceType.map((String value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.grey.withOpacity(0.3),
                                thickness: 10,
                              ),
                              Column(
                                children: [
                                  const Text("Số tiền hoàn lại"),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      (Utils.convertPriceVND(totalMoney)),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey.withOpacity(0.3),
                                thickness: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Lí do'),
                                  TextFormField(
                                    controller: controller,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z 0-9\u00E0-\u1EF9]"))
                                    ],
                                    minLines:
                                        6, // any number you need (It works as the rows for the textarea)
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    maxLength: 2000,
                                    decoration: const InputDecoration(
                                        hintText: 'Mô tả thêm........'),
                                    onTapOutside: (event) {
                                      focus.unfocus();
                                    },
                                    focusNode: focus,
                                    onEditingComplete: () {
                                      setState(() {
                                        text.add(controller.text);
                                      });
                                    },
                                    onChanged: (value) {},
                                  ),
                                  SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: thumbByte != null
                                        ? Stack(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      width: 200,
                                                      height: 200,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 2)),
                                                      child: Image.memory(
                                                        thumbByte!,
                                                        width: 200,
                                                        height: 200,
                                                      )),
                                                ],
                                              ),
                                            ],
                                          )
                                        : InkWell(
                                            onTap: () => selectImageOrVideo(),
                                            child: Container(
                                                width: 200,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                    border:
                                                        Border.all(width: 2)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(Icons.add),
                                                    Text('Thêm Video/Ảnh')
                                                  ],
                                                ))),
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        final newfile =
                                            await video!.file!.readAsBytes();
                                        await FirebaseStorageService()
                                            .uploadFileVideo(
                                                newfile, xFile!.name)
                                            .then((value) {
                                          log(value.toString());
                                          setState(() {
                                            list2.add(value!);
                                            text.add(controller.text);
                                          });
                                          return null;
                                        });

                                        getdata().then((vaule) {
                                          LoadingDialog.showLoadingDialog(
                                              context, "Vui Lòng Đợi");
                                          if (vaule.isSuccess!) {
                                            if (mounted) {
                                              LoadingDialog.hideLoadingDialog(
                                                  context);
                                              showMyAlertDialog(
                                                      context, vaule.message!)
                                                  .then((_) => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MainScreen())));
                                            }
                                          } else {
                                            if (mounted) {
                                              LoadingDialog.hideLoadingDialog(
                                                  context);
                                              inspect(vaule);
                                              showMyAlertDialog(
                                                  context, vaule.message!);
                                            }
                                          }
                                        });
                                      },
                                      child: const Text('Xác Nhận')),
                                ],
                              ),
                            ]))))));
  }

  Future selectImageOrVideo() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: 200,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Chọn loại file',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pickVideo();
                          },
                          child: Card(
                              child: Column(children: [
                            Icon(
                              Icons.video_call_rounded,
                              size: 70,
                              color: mainColor,
                            ),
                            Text(
                              "Video",
                              style: TextStyle(color: mainColor),
                            )
                          ])),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Card(
                              child: Column(children: [
                            Icon(
                              Icons.image_rounded,
                              size: 70,
                              color: mainColor,
                            ),
                            Text(
                              "Ảnh",
                              style: TextStyle(color: mainColor),
                            )
                          ])),
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }

  Future pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    final file = File(pickedFile.path);
    final thumbnailByte = await VideoCompress.getByteThumbnail(file.path);
    await VideoCompress.setLogLevel(0);
    video = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    setState(() {
      thumbByte = thumbnailByte;
      xFile = pickedFile;
    });

    inspect(listPick);
  }
}
