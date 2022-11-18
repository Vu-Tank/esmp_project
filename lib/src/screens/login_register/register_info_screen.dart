import 'dart:developer';
import 'dart:io';

import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/providers/user/register_provider.dart';
import 'package:esmp_project/src/repositoty/firebase_storage.dart';
import 'package:esmp_project/src/screens/google_map/google_map_Screen.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/show_modal_bottom_sheet_image.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';

class RegisterInfoScreen extends StatefulWidget {
  const RegisterInfoScreen({Key? key, required this.token, required this.phone, required this.uid})
      : super(key: key);
  final String token;
  final String phone;
  final String? uid;

  @override
  State<RegisterInfoScreen> createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  // File? image;
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
    // final mapProvider = Provider.of<GoogleMapProvider>(context);
    final registerProvider = Provider.of<RegisterProvider>(context);
    registerProvider.setPhoneNumber(widget.phone);
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Đăng ký",
          style: appBarTextStyle,
        )),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                    registerProvider.addressMapValid.error ?? '',
                    style: textStyleError,
                  ),
                  IconButton(
                      onPressed: () async{
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GoogleMapScreen(status: 'create')))
                            .then((value) {
                              if(value!=null){
                                registerProvider.setAddressFromMap(value);
                                log(value.toString());
                                log(registerProvider.address.toString());
                              }
                        });
                        log(registerProvider.address.toString());
                      },
                      icon: const Icon(Icons.my_location)),
                ],
              ),
              registerProvider.address!=null
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
                                  '${registerProvider.address!.province}',
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
                                  '${registerProvider.address!.district}',
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
                                  '${registerProvider.address!.ward}',
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
                decoration: buildInputDecoration(
                    "Email", Icons.mail_outline, registerProvider.email.error),
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
                    if (!registerProvider
                        .validAddress(_addressController.text.trim())) {
                      isValid = false;
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
                      LoadingDialog.showLoadingDialog(context, 'Vui lòng đợi');
                      // if (image != null) {
                      //   String fileName = image!.path.split('/').last;
                      //   String exFileName = fileName.split('.').last;
                      //   fileName = 'eSMP${Utils.createFile()}.$exFileName';
                      //   String? urlImage = await FirebaseStorageService()
                      //       .uploadFile(image!, fileName).catchError((error){
                      //         LoadingDialog.hideLoadingDialog(context);
                      //         showMyAlertDialog(context, error.toString());
                      //         isValid=false;
                      //   });
                      //   if(urlImage!=null){
                      //     registerProvider.setImage(
                      //         urlImage, image!.path.split('/').last);
                      //   }
                      // }
                      if(isValid){
                        await registerProvider.registerUser(widget.token,widget.uid, () {
                          LoadingDialog.hideLoadingDialog(context);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const LoginScreen()));
                          registerProvider.reset();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }, (String error) {
                          LoadingDialog.hideLoadingDialog(context);
                          showMyAlertDialog(context, error.toString());
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: Text("Đăng Ký", style: btnTextStyle),
                ),
              ),
            ],
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
              child: Image.network(
                AppUrl.defaultAvatar,
                fit: BoxFit.cover,
              ),
              //     : Image(
              //   image: AssetImage("assets/avatar1.jpg"),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
