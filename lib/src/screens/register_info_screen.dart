import 'dart:developer';
import 'dart:io';

import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/utils/widget/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/request_permission.dart';

class RegisterInfoScreen extends StatefulWidget {
  const RegisterInfoScreen({Key? key}) : super(key: key);

  @override
  State<RegisterInfoScreen> createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  File? image;

  @override
  Widget build(BuildContext context) {
    String? name;
    bool isValid = false;
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng ký"),
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
                SizedBox(
                  height: 20,
                ),
                //image profile
                imageProfile(),
                SizedBox(
                  height: 20,
                ),
                //ten
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Full Name",
                        style: TextStyle(color: Colors.grey, fontSize: 18)),
                    hintText: "Enter your name",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  onSaved: (String? value) {},
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      isValid = false;
                      return "Full Name is not empty!!!";
                    } else if (value.length <= 5) {
                      isValid = false;
                      return "The full name must be greater than 5 characters!!!";
                    }
                    isValid = true;
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                //address
                Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        label: Text("Address",
                            style: TextStyle(color: Colors.grey, fontSize: 18)),
                        hintText: "Enter your address",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/map");
                      },
                      icon:
                          Icon(Icons.my_location, size: 20, color: Colors.grey),
                    ),
                  ],
                ),
                //register
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    log('Name: ${name}');
                  },
                  child: Text("Sumbit"),
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
              size: Size.fromRadius(80),
              child: image != null
                  ? Image.file(
                      image!,
                      fit: BoxFit.cover,
                    )
                  : Image(
                      image: AssetImage("assets/avatar1.jpg"),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
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
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
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
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () async {
                  if (await requestPhotosPermission()) {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
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
