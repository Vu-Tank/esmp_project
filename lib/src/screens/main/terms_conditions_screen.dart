import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';

class TermAndCondititonScreen extends StatefulWidget {
  const TermAndCondititonScreen({super.key});

  @override
  State<TermAndCondititonScreen> createState() =>
      _TermAndCondititonScreenState();
}

class _TermAndCondititonScreenState extends State<TermAndCondititonScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Điều khoản'),
          centerTitle: true,
          backgroundColor: mainColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: listText.length,
            itemBuilder: (context, index) {
              if (listText[index].contains('I')) {
                return Text(
                  listText[index],
                  style: textStyleLabel.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                );
              }
              if (!listText[index].contains('I') &&
                  !listText[index].contains('-')) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    listText[index],
                    style: textStyleLabel.copyWith(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  listText[index],
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<String> listText = <String>[
    'I.	Điều kiện đăng ký.',
    '1.	Đối với vai trò bán hàng:',
    '-	Có đủ năng lực hành vi dân sự để thực hiện các giao dịch thương mại đối với sản phẩm bán trên hệ thống ESMP.',
    '-	Cung cấp đầy đủ thông tin cá nhân và thông tin về sản phẩm, dịch vụ cần bán.',
    '2.	Đối với vai trò mua hàng:',
    '-	Có đủ năng lực hành vi dân sự để thực hiện các giao dịch thương mại trên hệ thống ESMP.',
    '-	Cung cấp đầy đủ thông tin cá nhân và thông tin về địa chỉ giao hàng.',
    'II.	Điều kiện hoạt động.',
    '1.	Với vai trò bán hàng:',
    '-	Cam kết không bán hàng giả, hàng nhái, hàng kém chất lượng, không thực hiện hành vi vi phạm pháp luật và quy định của ESMP.',
    '-	Chịu trách nhiệm về việc đảm bảo chất lượng sản phẩm, dịch vụ cung cấp cho khách hàng.',
    '-	Tuân thủ quy trình, quy định và hướng dẫn của ESMP trong việc bán hàng, giao hàng, nhận thanh toán và đổi trả hàng hóa.',
    '2.	Với vai trò mua hàng:',
    '-	Cam kết không thực hiện hành vi vi phạm pháp luật và quy định của ESMP.',
    '-	Thực hiện thanh toán đầy đủ và đúng thời hạn đối với đơn hàng đã mua trên ESMP.',
    '-	Tuân thủ quy trình, quy định và hướng dẫn của ESMP trong việc mua hàng, đặt hàng, nhận hàng và đổi trả hàng hóa.',
    'III.	Quyền lợi và nghĩa vụ',
    '1.	Quyền lợi của người mua hàng:',
    '-	Được đảm bảo quyền lợi khi mua hàng trên hệ thống ESMP, bao gồm quyền lợi đổi trả, bảo vệ thông tin cá nhân và các thông tin giao dịch.',
    '-	Được cung cấp thông tin sản phẩm chính xác và đầy đủ, đảm bảo tính minh bạch và công bằng cho người mua.',
    '-	Được hỗ trợ khi gặp sự cố trong quá trình mua hàng trên hệ thống ESMP.',
    '2.	Quyền lợi của người bán hàng:',
    '-	Được cung cấp nền tảng bán hàng trực tuyến tiện lợi, phát triển kinh doanh và mở rộng thị trường.',
    '-	Được hỗ trợ trong việc tạo và quản lý gian hàng trên hệ thống ESMP.',
    '-	Được bảo vệ quyền sở hữu trí tuệ và ngăn chặn hành vi sao chép sản phẩm của người khác.',
    '-	Được đảm bảo quyền lợi khi bán hàng trên hệ thống ESMP, bao gồm quyền lợi về thanh toán và đổi trả hàng hóa.'
  ];
}
