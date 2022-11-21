import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user/edit_profile_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/cloud_firestore_service.dart';
import 'package:esmp_project/src/screens/profile/edit_dialog.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/request_permission.dart';
import '../../utils/widget/showSnackBar.dart';
import '../../utils/widget/show_modal_bottom_sheet_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final editProvider = Provider.of<EditProfileProvider>(context);
    UserModel user = userProvider.user!;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Hồ sơ',
            style: appBarTextStyle,
          ),
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //hình đại diện
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(60),
                    child: image != null
                        ? Image.file(
                            image!,
                            fit: BoxFit.cover,
                          )
                        // : Image.network(
                        //     user.image!.path!,
                        //     fit: BoxFit.cover,
                        //   ),
                        : CachedNetworkImage(
                            // item.itemImage,
                            // fit: BoxFit.cover,
                            imageUrl: user.image!.path!,
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
                          ),
                  ),
                ),
              ),
              onTap: () async {
                log(user.image!.path!);
                File? result =
                    await showModalBottomSheetImage(context).catchError((e) {
                  showMyAlertDialog(context, e.toString());
                });
                if (result != null) {
                  // log(result.toString());
                  if (mounted) {
                    LoadingDialog.showLoadingDialog(context, "Vui Lòng đợi");
                  }
                  await editProvider.editImage(
                      image: result,
                      userID: user.userID!,
                      token: user.token!,
                      userImage: user.image!.fileName!,
                      onSuccess: (UserModel user) {
                        CloudFirestoreService(uid: FirebaseAuth.instance.currentUser!.uid).updateUserImage(user.image!.path!);
                        userProvider.setUser(user);
                        setState(() {
                          image = result;
                        });
                        if (mounted) LoadingDialog.hideLoadingDialog(context);
                      },
                      onFailed: (String msg) {
                        if (mounted) LoadingDialog.hideLoadingDialog(context);
                        showMyAlertDialog(context, msg);
                      });
                }
              },
            ),
            //tên
            InkWell(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12),
                    top: BorderSide(color: Colors.black12),
                  ),
                ),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Họ và tên', style: textStyleInputChild),
                      Row(
                        children: [
                          Text(
                            '${user.userName}',
                            style: textStyleInputChild,
                          ),
                          const Icon(
                            Icons.edit_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                EditDialog().openDialog(
                  context: context,
                  title: 'Họ và tên',
                  hintText: "Nhập tên của bạn",
                  status: 'userName',
                  token: user.token!,
                  userId: user.userID!,
                  onSuccess: (UserModel user) {
                    userProvider.setUser(user);
                    controller.clear();
                    Navigator.pop(context);
                  },
                  onFailed: (String msg) {
                    Navigator.pop(context);
                    showSnackBar(context, msg);
                  },
                  controller: controller,
                );
              },
            ),
            //mail
            InkWell(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12),
                    top: BorderSide(color: Colors.black12),
                  ),
                ),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Email', style: textStyleInputChild),
                      Row(
                        children: [
                          Text(
                            '${user.email}',
                            style: textStyleInputChild,
                          ),
                          const Icon(
                            Icons.edit_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                EditDialog().openDialog(
                  context: context,
                  title: 'Email',
                  hintText: "Nhập email của bạn",
                  status: 'email',
                  token: user.token!,
                  userId: user.userID!,
                  onSuccess: (UserModel user) {
                    userProvider.setUser(user);
                    controller.clear();
                    Navigator.pop(context);
                  },
                  onFailed: (String msg) {
                    showSnackBar(context, msg);
                  },
                  controller: controller,
                );
              },
            ),
            // gender
            InkWell(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12),
                    top: BorderSide(color: Colors.black12),
                  ),
                ),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Giới tính', style: textStyleInputChild),
                      Row(
                        children: [
                          Text(
                            '${user.gender}',
                            style: textStyleInputChild,
                          ),
                          const Icon(
                            Icons.edit_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                EditDialog().openDialogGender(
                    context: context,
                    userId: user.userID!,
                    gender: user.gender!,
                    token: user.token!,
                    onSuccess: (UserModel user) {
                      userProvider.setUser(user);
                      LoadingDialog.hideLoadingDialog(context);
                      Navigator.pop(context);
                    },
                    onFailed: (String msg) {
                      LoadingDialog.hideLoadingDialog(context);
                      showSnackBar(context, msg);
                    });
              },
            ),
            // DOB
            InkWell(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12),
                    top: BorderSide(color: Colors.black12),
                  ),
                ),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Ngày sinh', style: textStyleInputChild),
                      Row(
                        children: [
                          Text(
                            user.dateOfBirth!.split('T')[0],
                            style: textStyleInputChild,
                          ),
                          const Icon(
                            Icons.edit_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                DateTime? dob = await showDatePicker(
                  context: context,
                  initialDate:
                      DateFormat("yyyy-MM-dd").parse(user.dateOfBirth!),
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
                ).then((value) async {
                  if (value != null) {
                    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                    String dob = dateFormat.format(value);
                    LoadingDialog.showLoadingDialog(context, 'Vui lòng đợi');
                    ApiResponse apiResponse = await context
                        .read<EditProfileProvider>()
                        .updateProfile(
                            value: dob,
                            status: 'dob',
                            token: user.token!,
                            userId: user.userID!);
                    if (apiResponse.isSuccess!) {
                      userProvider
                          .setUser(apiResponse.dataResponse as UserModel);
                      if (mounted) LoadingDialog.hideLoadingDialog(context);
                    } else {
                      if (mounted) LoadingDialog.hideLoadingDialog(context);
                      if (mounted) showSnackBar(context, apiResponse.message!);
                    }
                  } else {
                    return;
                  }
                });
              },
            ),
            // phone number
            InkWell(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12),
                    top: BorderSide(color: Colors.black12),
                  ),
                ),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Số Điện thoại', style: textStyleInputChild),
                      Row(
                        children: [
                          Text(
                            '+${user.phone}',
                            style: textStyleInputChild,
                          ),
                          const Icon(
                            Icons.edit_off_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                showSnackBar(context, "Không thể thay đổi số điện thoại");
              },
            ),
            // Ngày tham gia
            InkWell(
              child: Container(
                decoration:const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12),
                    top: BorderSide(color: Colors.black12),
                  ),
                ),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Ngày tham gia vào eSMP',
                          style: textStyleInputChild),
                      Row(
                        children: [
                          Text(
                            user.creteDate!.split('T')[0],
                            style: textStyleInputChild,
                          ),
                          const Icon(
                            Icons.edit_off_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                showSnackBar(context, "Không thể thay đổi");
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget bottomSheet({required onSuccess}) {
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
                    await pickImage(ImageSource.camera);
                    onSuccess();
                    if (mounted) Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.camera),
                label: const Text("Máy ảnh"),
              ),
              TextButton.icon(
                onPressed: () async {
                  if (await requestPhotosPermission()) {
                    await pickImage(ImageSource.gallery);
                    onSuccess();
                    if (mounted) Navigator.pop(context);
                  } else {
                    log("ko cấp quyền đc");
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text("Thư viện"),
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
