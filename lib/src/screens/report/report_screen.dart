import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/report_repository.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/showSnackBar.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key, required this.status, required this.id}) : super(key: key);
  final String status;
  final int id;
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tố cáo ${widget.id}',style: appBarTextStyle,),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Miêu tả tố cáo", style: textStyleInputChild,),
            const SizedBox(height: 10.0,),
            TextField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                maxLength: 100,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(5.0)),
                    ))),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          if(_controller.text.trim().isEmpty){
            showMyAlertDialog(context, "Vui lòng nhập miêu tả tố cáo");
            return;
          }
          if(_controller.text.trim().length<=10){
            showMyAlertDialog(context, "Vui lòng nhập nhiều hơn 10 ký tự.");
            return;
          }
          UserModel user= context.read<UserProvider>().user!;
          ApiResponse apiResponse=ApiResponse();
          LoadingDialog.showLoadingDialog(context, 'Vui lòng chờ');
          if(widget.status=='store'){
            apiResponse=await ReportRepository.reportStore(storeID: widget.id, userID: user.userID!, text: _controller.text.trim(), token: user.token!);
          }else if(widget.status=='item'){
            apiResponse=await ReportRepository.reportItem(itemID: widget.id, userID: user.userID!, text: _controller.text.trim(), token: user.token!);
          }else if(widget.status=='feedback'){
            apiResponse=await ReportRepository.reportFeedback(orderDetailID: widget.id, userID: user.userID!, text: _controller.text.trim(), token: user.token!);
          }
          if(apiResponse.isSuccess!){
            if(mounted){
              LoadingDialog.hideLoadingDialog(context);
              showSnackBar(context, apiResponse.message!);
              Navigator.pop(context);
            }
          }else{
            if(mounted){
              LoadingDialog.hideLoadingDialog(context);
              showMyAlertDialog(context, apiResponse.message!);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          padding: const EdgeInsets.only(
              top: 12.0, bottom: 12.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(8))),
        ),
        child: Text(
          'Xác nhận',
          style: btnTextStyle,
        ),
      ),
    );
  }
}
