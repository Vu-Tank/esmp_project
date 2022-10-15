import 'dart:developer';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user_provider.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/screens/address/address_screen.dart';
import 'package:esmp_project/src/screens/login_register/register_screen.dart';
import 'package:esmp_project/src/screens/proifle/profile_screen.dart';
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
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.deepOrangeAccent,
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
                    if(userProvider.user!=null){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddressScreen()));
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
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
                        onTap: () {},
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
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
                                  onTap: () {},
                                ),
                              ),
                            ),
                            //đamg giao
                            Container(
                              child: Expanded(
                                child: InkWell(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
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
                                  onTap: () {},
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
                  onTap: () {},
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
                  onTap: () async{
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()));
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
            child: Image.network(
              user.image!.path!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Text('${user.userName}'),
            TextButton(onPressed: () {
              log(user.image.toString());
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileScreen()));
            }, child: const Text('Thông tin tài khoản')),
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
