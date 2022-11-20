import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/main.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/cloud_firestore_service.dart';
import 'package:esmp_project/src/screens/address/address_screen.dart';
import 'package:esmp_project/src/screens/feedback/list_feedback_screen.dart';
import 'package:esmp_project/src/screens/login_register/register_screen.dart';
import 'package:esmp_project/src/screens/order/order.dart';
import 'package:esmp_project/src/screens/profile/profile_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/shared_preferences.dart';
import '../login_register/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: height,
            ),
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: mainColor,
              ),
              child: userProvider.user == null
                  ? notUser()
                  : userWidget(userProvider),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: <Widget>[
                //
                InkWell(
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12),
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.place_outlined,
                              color: Colors.grey,
                              size: 30,
                            ),
                            Text(
                              'Danh sách địa chỉ',
                              style: textStyleInputChild,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (userProvider.user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddressScreen(
                                    status: 'view',
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    }
                  },
                ),
                //đơn hàng của bạn
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // text đơn hàng
                      InkWell(
                        child: Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black12),
                              top: BorderSide(color: Colors.black12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.receipt_outlined,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  Text(
                                    'Đơn hàng',
                                    style: textStyleInputChild,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Xem lich sử mua hàng',
                                    style: textStyleLabelChild,
                                  ),
                                  const Icon(
                                    Icons.navigate_next,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          if (userProvider.user == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => LoginScreen()));
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => OrderMainScreen(
                                        index: 0,
                                      )));
                        },
                      ),
                      // row các loại đơn hàng
                      SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            //chờ lấy hàng
                            Container(
                              child: Expanded(
                                child: InkWell(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.move_to_inbox_outlined,
                                        size: 30,
                                      ),
                                      Text(
                                        'Chờ lấy hàng',
                                        style: textStyleLabelChild,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    if (userProvider.user == null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => LoginScreen()));
                                      return;
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => OrderMainScreen(
                                                  index: 2,
                                                )));
                                  },
                                ),
                              ),
                            ),
                            //đamg giao
                            Container(
                              child: Expanded(
                                child: InkWell(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.local_shipping_outlined,
                                        size: 30,
                                      ),
                                      Text(
                                        'Đang giao hàng',
                                        style: textStyleLabelChild,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    if (userProvider.user == null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const LoginScreen()));
                                      return;
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => OrderMainScreen(
                                                  index: 3,
                                                )));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // đánh giá
                InkWell(
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12),
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star_border_outlined,
                              color: Colors.grey,
                              size: 30,
                            ),
                            Text(
                              'Đánh giá',
                              style: textStyleInputChild,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (userProvider.user == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const LoginScreen()));
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListFeedBackScreen()));
                  },
                ),
                // chat vs hệ thống
                InkWell(
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12),
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.headset_mic_outlined,
                              color: Colors.grey,
                              size: 30,
                            ),
                            Text(
                              'Trò chuyện với eSMP',
                              style: textStyleInputChild,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    // await CloudFirestoreService(
                    //         uid: 'ObI3k1Q22Jbe449DokdrdNYIcrQ2')
                    //     .createUserCloud(
                    //         userName: 'huỳnh anh vũ', imageUrl: 'https://firebasestorage.googleapis.com/v0/b/esmp-4b85e.appspot.com/o/images%2F26-1c483a2e-86ed-48f3-b318-f85b96ccc65e?alt=media&token=29c33223-dd19-4607-b45d-1c85930a40b0').then((value){
                    //           showMyAlertDialog(context, 'msg');
                    // });
                    await CloudFirestoreService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .checkExistRoom('ObI3k1Q22Jbe449DokdrdNYIcrQ2')
                        .then((value) async {
                      if (value) {
                        showMyAlertDialog(context, "Mở chat screen");
                      } else {
                        await CloudFirestoreService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .createRoom(
                                otherUid: 'ObI3k1Q22Jbe449DokdrdNYIcrQ2')
                            .then((value) {
                          showMyAlertDialog(context, 'Thành công');
                        }).catchError((error) {
                          showMyAlertDialog(context, error.toString());
                        });
                      }
                    }).catchError((error) {
                      log(error.toString());
                      showMyAlertDialog(context, error.toString());
                    });
                  },
                ),
                //điều khoản đối vs khách hàng
                InkWell(
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12),
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.gavel_outlined,
                              color: Colors.grey,
                              size: 30,
                            ),
                            Text(
                              'Điều khoản eSMP',
                              style: textStyleInputChild,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget notUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        OutlinedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Text('Đăng nhập')),
        OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()));
            },
            child: const Text('Đăng Ký')),
      ],
    );
  }

  Widget userWidget(UserProvider userProvider) {
    UserModel user = userProvider.user!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(60),
            child: CachedNetworkImage(
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
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Text('${user.userName}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()));
                },
                child: const Text(
                  'Thông tin tài khoản',
                  style: TextStyle(fontSize: 16),
                )),
          ],
        ),
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              UserPreferences().removeUser();
              userProvider.logOut();
              Navigator.pushNamed(context, '/login');
            },
            icon: const Icon(Icons.logout))
      ],
    );
  }
}
