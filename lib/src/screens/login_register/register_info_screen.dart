import 'dart:io';

import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/providers/google_map_provider.dart';
import 'package:esmp_project/src/providers/register_provider.dart';
import 'package:esmp_project/src/repositoty/firebase_storage.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/showSnackBar.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/request_permission.dart';
import 'login_screen.dart';
import 'map_screen.dart';

class RegisterInfoScreen extends StatefulWidget {
  const RegisterInfoScreen({Key? key, required this.token, required this.phone})
      : super(key: key);
  final String token;
  final String phone;

  @override
  State<RegisterInfoScreen> createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  File? image;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<GoogleMapProvider>(context);
    final registerProvider = Provider.of<RegisterProvider>(context);
    registerProvider.setPhoneNumber(widget.phone);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Đăng ký")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            onChanged: () {
              Form.of(primaryFocus!.context!)!.save();
            },
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                //image profile
                imageProfile(),
                const SizedBox(
                  height: 20,
                ),
                //ten
                TextField(
                  decoration: buildInputDecoration(
                      "Họ Và Tên",
                      Icons.perm_identity_outlined,
                      registerProvider.fullName.error),
                  style: textStyleInput,
                  controller: _fullNameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                //address
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Địa chỉ",
                      style: textStyleLabel,
                    ),
                    Text(
                      mapProvider.mapStatus.error ?? '',
                      style: textStyleError,
                    ),
                    IconButton(
                        onPressed: () {
                          // mapProvider.updateStatus();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MapScreen()));
                        },
                        icon: const Icon(Icons.my_location)),
                  ],
                ),
                mapProvider.isUpdate
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Table(
                            children: [
                              TableRow(children: [
                                Text(
                                  'Tỉnh/ Thành phố :',
                                  style: textStyleLabelChild,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${mapProvider.addressModel.province}',
                                    style: textStyleInputChild,
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Text(
                                  'Quận/ Huyện :',
                                  style: textStyleLabelChild,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${mapProvider.addressModel.district}',
                                    style: textStyleInputChild,
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Text(
                                  'Phường/ Xã :',
                                  style: textStyleLabelChild,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${mapProvider.addressModel.ward}',
                                    style: textStyleInputChild,
                                  ),
                                ),
                              ])
                            ],
                          ),
                          TextField(
                            decoration: buildInputDecoration(
                                'Số nhà, tên đường (thôn, xóm)',
                                Icons.location_on_outlined,
                                registerProvider.addressValid.error),
                            controller: _addressController,
                          ),
                        ],
                      )
                    : const SizedBox(),
                // giới tính
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Giới tính", style: textStyleLabel),
                    SizedBox(
                      width: 80,
                      child: DropdownButton(
                        value: registerProvider.user.gender!,
                        icon: const Icon(Icons.arrow_downward),
                        isExpanded: true,
                        elevation: 16,
                        style: textStyleLabel,
                        underline: Container(
                          height: 2,
                          color: Colors.cyan,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          registerProvider.genderOnchange(value);
                        },
                        items: registerProvider.genders
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: textStyleInput,
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                //email
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: buildInputDecoration("Email", Icons.mail_outline,
                      registerProvider.email.error),
                  style: textStyleInput,
                  controller: _emailController,
                ),
                //ngay sinh
                const SizedBox(
                  height: 20,
                ),
                //ngày sinh
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Ngày Sinh:  ',
                        style: textStyleLabel,
                      ),
                      Text(
                        registerProvider.user.dateOfBirth ?? '',
                        style: textStyleInput,
                      ),
                      Text(
                        registerProvider.dob.error ?? '',
                        style: textStyleError,
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                  onTap: () async {
                    DateTime? dob = await showDatePicker(
                      context: context,
                      initialDate: DateTime(DateTime.now().year - 14,
                          DateTime.now().month, DateTime.now().day),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(DateTime.now().year + 1),
                      helpText: 'Ngày sinh',
                      selectableDayPredicate: (DateTime? date) {
                        if (DateTime.now().year - date!.year >= 14) {
                          if (DateTime.now().year - date.year == 14 &&
                              DateTime.now().month < date.month) {
                            return false;
                          } else if (DateTime.now().year - date.year == 14 &&
                              DateTime.now().month == date.month &&
                              DateTime.now().day < date.day) {
                            return false;
                          }
                          return true;
                        }
                        return false;
                      },
                    );
                    if (dob != null) {
                      registerProvider.selectDOB(dob);
                    } else {
                      return;
                    }
                  },
                ),
                //register
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isValid = true;
                      registerProvider.checkDOB();
                      if (registerProvider.user.dateOfBirth == null) {
                        isValid = false;
                      }
                      mapProvider.checkSelectMap();
                      if (!mapProvider.isUpdate) {
                        isValid = false;
                      } else {
                        if (!registerProvider
                            .validAddress(_addressController.text.trim())) {
                          isValid = false;
                        }
                        mapProvider.checkSelectMap();
                      }
                      if (!registerProvider
                          .validFullName(_fullNameController.text.trim())) {
                        isValid = false;
                      }
                      if (!registerProvider
                          .validEmail(_emailController.text.trim())) {
                        isValid = false;
                      }
                      if (isValid) {
                        LoadingDialog.showLoadingDialog(
                            context, 'Vui lòng đợi');
                        registerProvider
                            .setAddressFromMap(mapProvider.addressModel);
                        if (image != null) {
                          String? urlImage =
                              await FirebaseStorageService().uploadFile(image!);
                          registerProvider.setImage(
                              urlImage!, image!.path.split('/').last);
                        }
                        await registerProvider.registerUser(widget.token, () {
                          LoadingDialog.hideLoadingDialog(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        }, (String error) {
                          showSnackBar(context, error);
                        });
                        if (mounted) LoadingDialog.hideLoadingDialog(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    child: const Text("Đăng Ký",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(60),
              child: image != null
                  ? Image.file(
                      image!,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      AppUrl.defaultAvatar,
                      fit: BoxFit.cover,
                    ),
              //     : Image(
              //   image: AssetImage("assets/avatar1.jpg"),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: const Icon(
                Icons.camera_alt,
                color: Colors.black54,
                size: 30,
              )),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  if (await requestCameraPermission(context)) {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.camera),
                label: const Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () async {
                  if (await requestPhotosPermission()) {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text("Gallery"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      showSnackBar(context, 'Failed to pick image: $e');
    }
  }
}
