import 'dart:async';
import 'dart:developer';

import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user/address_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/showSnackBar.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddressDetailScreen extends StatefulWidget {
  const AddressDetailScreen({Key? key, required this.status, this.address})
      : super(key: key);
  final String status;
  final AddressModel? address;

  @override
  State<AddressDetailScreen> createState() => _AddressDetailScreenState();
}

class _AddressDetailScreenState extends State<AddressDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    if (widget.status == "edit") {
      AddressModel addressModel = widget.address!;
      context.read<AddressProvider>().setAddress(addressModel);
      _nameController.text = addressModel.userName!;
      _phoneController.text = addressModel.userPhone!;
      _addressController.text = addressModel.context!;
    } else if (widget.status == "create") {
      context.read<AddressProvider>().setAddress(null);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().initProvince().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    UserModel user = context.read<UserProvider>().user!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Địa chỉ của tôi',
          style: appBarTextStyle,
        ),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //lien he
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'liên hệ',
                      style: textStyleLabelChild,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      decoration: buildInputDecoration(
                          'Họ và tên',
                          Icons.perm_identity_outlined,
                          addressProvider.validUserName.error),
                      style: textStyleInput,
                      controller: _nameController,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      decoration: buildInputDecoration('Số điện thoại',
                          Icons.phone, addressProvider.validUserPhone.error),
                      style: textStyleInput,
                      controller: _phoneController,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Địa chỉ',
                      style: textStyleLabelChild,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //tỉnh
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                          child: DropdownButtonFormField(
                            value: addressProvider.selectedProvince,
                            icon: const Icon(Icons.arrow_downward),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(40)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: mainColor, width: 2),
                                  borderRadius: BorderRadius.circular(40)),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            isExpanded: true,
                            elevation: 16,
                            style: textStyleLabel,
                            onChanged: (Province? value) {
                              addressProvider.onChangeProvince(value);
                            },
                            items: addressProvider.listProvince
                                .map<DropdownMenuItem<Province>>(
                                    (Province value) {
                              return DropdownMenuItem<Province>(
                                value: value,
                                child: Text(
                                  value.name,
                                  style: textStyleInput,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        //quan
                        if (addressProvider.selectedProvince != null &&
                            addressProvider.selectedProvince!.code != '-1')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: DropdownButtonFormField(
                              value: addressProvider.selectedDistrict,
                              icon: const Icon(Icons.arrow_downward),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 2),
                                    borderRadius: BorderRadius.circular(40)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: mainColor, width: 2),
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              isExpanded: true,
                              elevation: 16,
                              style: textStyleLabel,
                              onChanged: (District? value) {
                                addressProvider.onChangeDistrict(value);
                              },
                              items: addressProvider
                                  .selectedProvince!.listDistrict
                                  .map<DropdownMenuItem<District>>(
                                      (District value) {
                                return DropdownMenuItem<District>(
                                  value: value,
                                  child: Text(
                                    value.name_with_type,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: textStyleInput,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        //phuong
                        if (addressProvider.selectedDistrict != null &&
                            addressProvider.selectedDistrict!.code != '-1')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: DropdownButtonFormField(
                              value: addressProvider.selectedWard,
                              icon: const Icon(Icons.arrow_downward),
                              isExpanded: true,
                              elevation: 16,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 2),
                                    borderRadius: BorderRadius.circular(40)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: mainColor, width: 2),
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              style: textStyleLabel,
                              onChanged: (Ward? value) {
                                addressProvider.onChangeWard(value);
                              },
                              items: addressProvider.selectedDistrict!.listWard
                                  .map<DropdownMenuItem<Ward>>((Ward value) {
                                return DropdownMenuItem<Ward>(
                                  value: value,
                                  child: Text(
                                    value.name_with_type,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: textStyleInput,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        //đuong
                        if (addressProvider.selectedWard != null &&
                            addressProvider.selectedWard!.code != '-1')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextField(
                              decoration: buildInputDecoration(
                                  'Số nhà, tên đường (thôn, xóm)',
                                  Icons.location_on_outlined,
                                  // registerProvider.addressValid.error),
                                  null),
                              style: textStyleInput,
                              controller: _addressController,
                            ),
                          ),
                        if (addressProvider.addressValid.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              addressProvider.addressValid.error!,
                              style: textStyleError,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                      ],
                    ),
                    // (widget.status == 'create' &&
                    //     addressProvider.addressModel == null)
                    //     ? SizedBox(
                    //   width: double.infinity,
                    //   height: 50,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) =>
                    //                   GoogleMapScreen(status: 'create')))
                    //           .then((value) =>
                    //       {
                    //         if (value != null)
                    //           {
                    //             _goToPlace(value),
                    //             addressProvider.setNewAddress(value),
                    //           }
                    //       });
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.white,
                    //       shape: const RoundedRectangleBorder(
                    //           borderRadius:
                    //           BorderRadius.all(Radius.circular(8))),
                    //     ),
                    //     child: const Text("Chọn địa chỉ trên bản đồ",
                    //         style:
                    //         TextStyle(color: Colors.black, fontSize: 15)),
                    //   ),
                    // )
                    //     : Column(
                    //   children: <Widget>[
                    //     const SizedBox(
                    //       height: 8,
                    //     ),
                    //     InkWell(
                    //       child: Text(
                    //         '${addressProvider.addressModel!.ward}, ${addressProvider
                    //             .addressModel!.district}, ${addressProvider
                    //             .addressModel!.province}',
                    //         style: textStyleInputChild,
                    //       ),
                    //       onTap: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     GoogleMapScreen(
                    //                       status: 'edit',
                    //                       addressModel: widget.address,
                    //                     ))).then((value) {
                    //           if (value != null) {
                    //             _goToPlace(value);
                    //             addressProvider.setNewAddress(value);
                    //           }
                    //         });
                    //       },
                    //     ),
                    //     const SizedBox(
                    //       height: 8,
                    //     ),
                    //     TextField(
                    //       decoration: buildInputDecoration(
                    //           'Số nhà, đường (thôn, xóm)',
                    //           Icons.location_on_outlined,
                    //           addressProvider.validContext.error),
                    //       controller: _addressController,
                    //       style: textStyleInputChild,
                    //     ),
                    //     const SizedBox(
                    //       height: 8,
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: SizedBox(
                    //         height: 300,
                    //         width: double.infinity,
                    //         child: GoogleMap(
                    //           mapType: MapType.normal,
                    //           onMapCreated: (GoogleMapController controller) {
                    //             _controller.complete(controller);
                    //           },
                    //           initialCameraPosition: CameraPosition(
                    //             target: LatLng(
                    //                 addressProvider.addressModel!.latitude!,
                    //                 addressProvider.addressModel!.longitude!),
                    //             zoom: 16,
                    //           ),
                    //           myLocationEnabled: false,
                    //           myLocationButtonEnabled: false,
                    //           zoomControlsEnabled: false,
                    //           scrollGesturesEnabled: false,
                    //           onTap: (LatLng latLng) {
                    //             Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) =>
                    //                         GoogleMapScreen(
                    //                           status: 'edit',
                    //                           addressModel: widget.address,
                    //                         ))).then((value) {
                    //               if (value != null) {
                    //                 _goToPlace(value);
                    //                 addressProvider.setNewAddress(value);
                    //                 log(addressProvider.addressModel!.toString());
                    //               }
                    //             });
                    //           },
                    //           markers: {
                    //             Marker(
                    //                 markerId: const MarkerId('value'),
                    //                 position: LatLng(
                    //                     addressProvider.addressModel!.latitude!,
                    //                     addressProvider.addressModel!.longitude!),
                    //                 icon: BitmapDescriptor.defaultMarker),
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 8,
                    ),
                    (widget.status == "edit")
                        ? SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: (context
                                          .read<UserProvider>()
                                          .user!
                                          .address!
                                          .length ==
                                      1)
                                  ? null
                                  : () async {
                                      ApiResponse apiResponse =
                                          await UserRepository.deleteAddress(
                                              addressID: addressProvider
                                                  .addressModel!.addressID!,
                                              token: context
                                                  .read<UserProvider>()
                                                  .user!
                                                  .token!);
                                      if (apiResponse.isSuccess!) {
                                        if (mounted) {
                                          context
                                              .read<UserProvider>()
                                              .deleteAddress(addressProvider
                                                  .addressModel!.addressID!);
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        if (mounted) {
                                          showSnackBar(
                                              context, apiResponse.message!);
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                              ),
                              child: Text("Xóa địa chỉ",
                                  style:
                                      btnTextStyle.copyWith(color: mainColor)),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool check = true;
                          if (!addressProvider
                              .validName(_nameController.text.trim())) {
                            check = false;
                          }
                          if (!addressProvider
                              .validPhone(_phoneController.text.trim())) {
                            check = false;
                          }
                          if (!await addressProvider
                              .validAddress(_addressController.text.trim())) {
                            check = false;
                          }
                          log('Check: $check');
                          if (check) {
                            if (widget.status == "edit") {
                              if (mounted) {
                                LoadingDialog.showLoadingDialog(
                                    context, "Vui lòng đợi");
                              }
                              await addressProvider.updateAddress(
                                  token: user.token!,
                                  onSuccess: (AddressModel address) {
                                    context
                                        .read<UserProvider>()
                                        .setAddress(address);
                                    LoadingDialog.hideLoadingDialog(context);
                                    Navigator.pop(context);
                                  },
                                  onFailed: (String msg) {
                                    LoadingDialog.hideLoadingDialog(context);
                                    showMyAlertDialog(context, msg);
                                  });
                            } else if (widget.status == "create") {
                              log(user.userID.toString());
                              if (mounted) {
                                LoadingDialog.showLoadingDialog(
                                    context, "Vui lòng đợi");
                              }
                              await addressProvider.createAddress(
                                  userID: user.userID!,
                                  token: user.token!,
                                  onSuccess: (List<AddressModel> listAddress) {
                                    context
                                        .read<UserProvider>()
                                        .setListAddress(listAddress);
                                    LoadingDialog.hideLoadingDialog(context);
                                    Navigator.pop(context);
                                  },
                                  onFailed: (String msg) {
                                    LoadingDialog.hideLoadingDialog(context);
                                    showMyAlertDialog(context, msg);
                                  });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        child: Text("Hoàn thành", style: btnTextStyle),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  // Future<void> _goToPlace(AddressModel address) async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(
  //         target: LatLng(address.latitude!, address.longitude!), zoom: 15),
  //   ));
  // }
}
