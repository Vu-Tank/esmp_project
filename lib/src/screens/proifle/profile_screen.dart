import 'dart:io';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user_provider.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/screens/proifle/edit_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/request_permission.dart';
import '../../utils/widget/showSnackBar.dart';

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
    UserModel user = userProvider.user!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hồ sơ',
          style: textStyleInput,
        ),
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
                    size: Size.fromRadius(60),
                    child: image != null
                        ? Image.file(
                            image!,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            user.image!.path!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet(onSuccess: () async {
                        if (image != null) {
                          ApiResponse apiResponse =
                              await UserRepository.editImage(
                                  userId: user.userID!,
                                  token: user.token!,
                                  path: image!.path,
                                  fileName: image!.path.split('/').last);
                          if (apiResponse.isSuccess!) {
                            ImageModel imageModel =
                                apiResponse.dataResponse as ImageModel;
                            userProvider.setUserImage(imageModel);
                          }
                        }
                      })),
                );
              },
            ),
            //tên
            InkWell(
              child: Container(
                decoration: BoxDecoration(
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
                          Icon(
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
                    showSnackBar(context, msg);
                  },
                  controller: controller,
                );
              },
            ),
            //mail
            InkWell(
              child: Container(
                decoration: BoxDecoration(
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
                          Icon(
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
                decoration: BoxDecoration(
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
                          Icon(
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
                    onSuccess: (){
                      Navigator.pop(context);
                    },
                    onFailed: (String msg){
                      showSnackBar(context, msg);
                    });
              },
            ),
            // DOB
            InkWell(
              child: Container(
                decoration: BoxDecoration(
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
                          Icon(
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
                } else {
                  return;
                }
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
                          Icon(
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
                decoration: BoxDecoration(
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
                          Icon(
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
                    pickImage(ImageSource.camera);
                    onSuccess();
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.camera),
                label: const Text("Máy ảnh"),
              ),
              TextButton.icon(
                onPressed: () async {
                  if (await requestPhotosPermission()) {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
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
