import 'dart:async';
import 'dart:developer';

import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user/address_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/screens/google_map/google_map_Screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.status == "edit") {
      AddressModel addressModel = widget.address!;
      context.read<AddressProvider>().setAddress(addressModel);
      _nameController.text = addressModel.userName!;
      _phoneController.text = addressModel.userPhone!;
      _addressController.text = addressModel.context!;
    } else if (widget.status == "create") {
      context.read<AddressProvider>().setAddress(null);
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Địa chỉ của tôi', style: appBarTextStyle,),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //lien he
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
                decoration: buildInputDecoration('Số điện thoại', Icons.phone,
                    addressProvider.validUserPhone.error),
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
              (widget.status == 'create' &&
                  addressProvider.addressModel == null)
                  ? SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GoogleMapScreen(status: 'create')))
                        .then((value) =>
                    {
                      if (value != null)
                        {
                          _goToPlace(value),
                          addressProvider.setNewAddress(value),
                        }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8))),
                  ),
                  child: const Text("Chọn địa chỉ trên bản đồ",
                      style:
                      TextStyle(color: Colors.black, fontSize: 15)),
                ),
              )
                  : Column(
                children: <Widget>[
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    child: Text(
                      '${addressProvider.addressModel!.ward}, ${addressProvider
                          .addressModel!.district}, ${addressProvider
                          .addressModel!.province}',
                      style: textStyleInputChild,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GoogleMapScreen(
                                    status: 'edit',
                                    addressModel: widget.address,
                                  ))).then((value) {
                        if (value != null) {
                          _goToPlace(value);
                          addressProvider.setNewAddress(value);
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: buildInputDecoration(
                        'Số nhà, đường (thôn, xóm)',
                        Icons.location_on_outlined,
                        addressProvider.validContext.error),
                    controller: _addressController,
                    style: textStyleInputChild,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              addressProvider.addressModel!.latitude!,
                              addressProvider.addressModel!.longitude!),
                          zoom: 16,
                        ),
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        scrollGesturesEnabled: false,
                        onTap: (LatLng latLng) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GoogleMapScreen(
                                        status: 'edit',
                                        addressModel: widget.address,
                                      ))).then((value) {
                            if (value != null) {
                              _goToPlace(value);
                              addressProvider.setNewAddress(value);
                              log(addressProvider.addressModel!.toString());
                            }
                          });
                        },
                        markers: {
                          Marker(
                              markerId: const MarkerId('value'),
                              position: LatLng(
                                  addressProvider.addressModel!.latitude!,
                                  addressProvider.addressModel!.longitude!),
                              icon: BitmapDescriptor.defaultMarker),
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              if (addressProvider.validLocation.error != null)
                Text(
                  addressProvider.validLocation.error!,
                  style: textStyleError,
                ),
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
                        context.read<UserProvider>().deleteAddress(
                            addressProvider
                                .addressModel!.addressID!);
                        Navigator.pop(context);
                      }
                    } else {
                      if (mounted) {
                        showSnackBar(context, apiResponse.message!);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8))),
                  ),
                  child: const Text("Xóa địa chỉ",
                      style: TextStyle(color: Colors.red, fontSize: 15)),
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
                    if (!addressProvider
                        .validContex(_addressController.text.trim())) {
                      check = false;
                    }
                    if (!addressProvider.isValidLocation()) {
                      check = false;
                    }
                    log('Check: $check');
                    if (check) {
                      addressProvider.addressModel!.userPhone =
                          Utils.convertToDB(
                              addressProvider.addressModel!.userPhone!);
                      if (widget.status == "edit") {
                        ApiResponse apiResponse =
                        await UserRepository.updateAddress(
                            addressModel: addressProvider.addressModel!,
                            token:
                            context
                                .read<UserProvider>()
                                .user!
                                .token!);
                        if (apiResponse.isSuccess!) {
                          if (mounted) {
                            context
                                .read<UserProvider>()
                                .setAddress(addressProvider.addressModel!);
                            Navigator.pop(context);
                          }
                        } else {
                          if (mounted) {
                            showSnackBar(context, apiResponse.message!);
                          }
                        }
                      } else if (widget.status == "create") {
                        ApiResponse apiResponse =
                        await UserRepository.createAddress(
                            addressModel: addressProvider.addressModel!,
                            userID:
                            context
                                .read<UserProvider>()
                                .user!
                                .userID!,
                            token:
                            context
                                .read<UserProvider>()
                                .user!
                                .token!);
                        if (apiResponse.isSuccess!) {
                          if (mounted) {
                            context.read<UserProvider>().setListAddress(
                                apiResponse.dataResponse as List<AddressModel>);
                            Navigator.pop(context);
                          }
                        } else {
                          if (mounted) {
                            showSnackBar(context, apiResponse.message!);
                          }
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: Text("Hoàn thành",
                      style: btnTextStyle),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToPlace(AddressModel address) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(address.latitude!, address.longitude!), zoom: 15),
    ));
  }
}
