import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/cloud_firestore_service.dart';
import 'package:esmp_project/src/repositoty/system_repository.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/screens/address/address_screen.dart';
import 'package:esmp_project/src/screens/chat/chat_detail_screen.dart';
import 'package:esmp_project/src/screens/feedback/list_feedback_screen.dart';
import 'package:esmp_project/src/screens/login_register/register_screen.dart';
import 'package:esmp_project/src/screens/order/order.dart';
import 'package:esmp_project/src/screens/profile/profile_screen.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
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
                  : userWidget(userProvider.user!),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //địa chỉ
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: InkWell(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(20),
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
                  ),
                  //đơn hàng của bạn
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20),
                      ),
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
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.receipt_outlined,
                                        color: Colors.grey,
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
                                        builder: (ctx) => const LoginScreen()));
                                return;
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => const OrderMainScreen(
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
                                                builder: (ctx) =>
                                                    const OrderMainScreen(
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
                                                builder: (ctx) =>
                                                    const OrderMainScreen(
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
                  ),
                  // đánh giá
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: InkWell(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(20),
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
                                builder: (context) =>
                                    const ListFeedBackScreen()));
                      },
                    ),
                  ),
                  // chat vs hệ thống
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: InkWell(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(20),
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
                        if (userProvider.user == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                          return;
                        }
                        // await CloudFirestoreService(uid: '6yfC0FnFaFfXnrI9eZxOrxnR8Bd2').createUserCloud(userName: 'Admin', imageUrl: 'data:image/png;base64,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').then((value){
                        //   showMyAlertDialog(context, "Thành công");
                        // });
                        ApiResponse apiResponse =
                            await SystemRepository.getUidSystem(
                                token: userProvider.user!.token!);
                        if (apiResponse.isSuccess!) {
                          await CloudFirestoreService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .checkExistRoom(
                                  apiResponse.dataResponse.toString())
                              .then((value) async {
                            if (value != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatDetailScreen(roomChat: value)));
                            } else {
                              await CloudFirestoreService(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .createRoom(
                                      otherUid:
                                          apiResponse.dataResponse.toString())
                                  .then((value) {
                                if (value != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatDetailScreen(
                                                  roomChat: value)));
                                }
                              }).catchError((error) {
                                showMyAlertDialog(context, error.toString());
                              });
                            }
                          }).catchError((error) {
                            log(error.toString());
                            showMyAlertDialog(context, error.toString());
                          });
                        } else {
                          if (mounted) {
                            showMyAlertDialog(context, apiResponse.message!);
                          }
                        }
                      },
                    ),
                  ),
                  //điều khoản đối vs khách hàng
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: InkWell(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.policy_outlined,
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
                  ),
                  // login and register
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: (userProvider.user == null)
                        ? Column(
                            children: [
                              SizedBox(
                                height: 60,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: btnColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                  ),
                                  child: Text(
                                    'Đăng nhập',
                                    style: btnTextStyle,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              SizedBox(
                                height: 60,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: btnColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                  ),
                                  child: Text(
                                    'Đăng ký',
                                    style: btnTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                String? result = await showConfirmDialog(
                                    context, "Bạn chắc chắn muốn đăng xuất?");
                                if (result != null) {
                                  if (result == 'Ok') {
                                    if (mounted) {
                                      LoadingDialog.showLoadingDialog(
                                          context, "Vui lòng đợi");
                                    }
                                    ApiResponse apiResponse =
                                        await UserRepository.logout(
                                            userProvider.user!.userID!,
                                            userProvider.user!.token!);
                                    if (apiResponse.isSuccess!) {
                                      FirebaseAuth.instance.signOut();
                                      UserPreferences().removeUser();
                                      userProvider.logOut();
                                      if (mounted) {
                                        LoadingDialog.hideLoadingDialog(
                                            context);
                                        Navigator.pushNamed(context, '/login');
                                      }
                                    } else {
                                      log(apiResponse.message!);
                                      if (mounted) {
                                        LoadingDialog.hideLoadingDialog(
                                            context);
                                        showMyAlertDialog(
                                            context, apiResponse.message!);
                                      }
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: btnColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              child: Text(
                                'Đăng xuất',
                                style: btnTextStyle,
                              ),
                            ),
                          ),
                  ),
                  // create user
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 4.0,bottom: 4.0),
                  //   child: SizedBox(
                  //     height: 60,
                  //     width: double.infinity,
                  //     child: ElevatedButton(
                  //       onPressed: ()async{
                  //         // await CloudFirestoreService(uid: FirebaseAuth.instance.currentUser!.uid).createUserCloud(userName: 'Huỳnh Anh vũ', imageUrl: 'https://firebasestorage.googleapis.com/v0/b/esmp-4b85e.appspot.com/o/images%2F16-1c8843e5-4dd0-4fb7-b061-3a9fcbd68c0d?alt=media&token=0c8838a5-d3c4-4c31-82ed-d9b91d8c11d9-3a9fcbd68c0d%3Falt%3Dmedia%26token%3D0c8838a5-d3c4-4c31-82ed-d9b91d8c11d9%26fbclid%3DIwAR0v68PcVs-E38YszRIZPyNy4PaYRZU59b21d-iyQ8NTyBrvXYp3YBqKclQ&h=AT0F7Fm4W02bljIiOCCdNFraaSuuADp6xPHlwhoYbjufje1E8RgzWN2FGd6VMBRyqTf3FUfZTqL06dMVX9L_KUFIKX3uDnn11IbTYz6Sy3S1K3bJYBxQeouYAqKg8loyuiQ4dg').then((value){
                  //         //   showMyAlertDialog(context, 'thành công');
                  //         // }).catchError((e){
                  //         //   showMyAlertDialog(context, e.toString());
                  //         // });
                  //         await CloudFirestoreService(uid: FirebaseAuth.instance.currentUser!.uid).createRoom(otherUid: 'ovWpt8C1QoUaCbZoFUmoQlaslD13');
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: btnColor,
                  //         shape: const RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.all(
                  //                 Radius.circular(20))),
                  //       ),
                  //       child: Text(
                  //         'Tạo ',
                  //         style: btnTextStyle,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notUser() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(50),
              child: CachedNetworkImage(
                // item.itemImage,
                // fit: BoxFit.cover,
                imageUrl: AppUrl.defaultAvatar,
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
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text('Chưa đăng nhâp',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 8.0,
                ),
                Text('Đăng nhập để mở khoá những tính năng thú vị hơn',
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userWidget(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(50),
              child: CachedNetworkImage(
                // item.itemImage,
                // fit: BoxFit.cover,
                imageUrl: user.image!.path!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.white),
                    borderRadius: BorderRadius.circular(100),
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
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${user.userName}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 8.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()));
                  },
                  child: const Text('Xem hồ sơ',
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                )
              ],
            ),
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     const SizedBox(
          //       height: 50,
          //     ),
          //     Text('${user.userName}',
          //         style:
          //             const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          //     TextButton(
          //         onPressed: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => const ProfileScreen()));
          //         },
          //         child: const Text(
          //           'Thông tin tài khoản',
          //           style: TextStyle(fontSize: 16),
          //         )),
          //   ],
          // ),
          // IconButton(
          //     onPressed: () async {
          //       LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
          //       ApiResponse apiResponse =
          //           await UserRepository.logout(user.userID!, user.token!);
          //       if (apiResponse.isSuccess!) {
          //         FirebaseAuth.instance.signOut();
          //         UserPreferences().removeUser();
          //         userProvider.logOut();
          //         if (mounted) {
          //           LoadingDialog.hideLoadingDialog(context);
          //           Navigator.pushNamed(context, '/login');
          //         }
          //       } else {
          //         log(apiResponse.message!);
          //         if (mounted) {
          //           LoadingDialog.hideLoadingDialog(context);
          //           showMyAlertDialog(context, apiResponse.message!);
          //         }
          //       }
          //     },
          //     icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
