import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/providers/user/register_provider.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterInfoScreen extends StatefulWidget {
  const RegisterInfoScreen(
      {Key? key, required this.token, required this.phone, required this.uid})
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
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final registerProvider = context.read<RegisterProvider>();
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      registerProvider.initProvince().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    double width = MediaQuery.of(context).size.width;
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //tỉnh
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: DropdownButtonFormField(
                            value: registerProvider.selectedProvince,
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
                              registerProvider.onChangeProvince(value);
                            },
                            items: registerProvider.listProvince
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
                        if (registerProvider.selectedProvince != null &&
                            registerProvider.selectedProvince!.code != '-1')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: DropdownButtonFormField(
                              value: registerProvider.selectedDistrict,
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
                                registerProvider.onChangeDistrict(value);
                              },
                              items: registerProvider
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
                        if (registerProvider.selectedDistrict != null &&
                            registerProvider.selectedDistrict!.code != '-1')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: DropdownButtonFormField(
                              value: registerProvider.selectedWard,
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
                                registerProvider.onChangeWard(value);
                              },
                              items: registerProvider.selectedDistrict!.listWard
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
                        if (registerProvider.selectedWard != null &&
                            registerProvider.selectedWard!.code != '-1')
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
                        if (registerProvider.addressValid.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              registerProvider.addressValid.error!,
                              style: textStyleError,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                      ],
                    ),
                    //giới tính
                    Row(
                      children: <Widget>[
                        Text("Giới tính", style: textStyleLabel),
                        SizedBox(
                          width: width * 1 / 5,
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                            value: registerProvider.user.gender!,
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
                            elevation: 16,
                            style: textStyleLabel,
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
                        ),
                      ],
                    ),
                    //email
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: buildInputDecoration("Email",
                          Icons.mail_outline, registerProvider.email.error),
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
                              } else if (DateTime.now().year - date.year ==
                                      14 &&
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
                          FocusManager.instance.primaryFocus?.unfocus();
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
                            LoadingDialog.showLoadingDialog(
                                context, 'Vui lòng đợi');
                            if (isValid) {
                              await registerProvider.registerUser(
                                  widget.token,
                                  widget.uid,
                                  _addressController.text.trim(), () {
                                LoadingDialog.hideLoadingDialog(context);
                                showMyAlertDialog(
                                    context, 'Đăng ký thành công');
                                registerProvider.reset();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
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
