import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';

class InformationEsmpScreen extends StatelessWidget {
  const InformationEsmpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Liên Hệ')),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset("assets/images/online_shop.png"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Liên Hệ ESMP',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Mọi thắc mắc hoặc yêu cầu hỗ trợ? Xin liên hệ theo các thông tin dưới đây:',
                        maxLines: 4,
                        style: TextStyle(fontSize: 20),
                      ),
                      const Icon(
                        Icons.facebook_outlined,
                        size: 100,
                        color: Colors.blueAccent,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Facebook',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          )),
                      const Icon(
                        Icons.phone,
                        size: 100,
                      ),
                      const Text('0333849975',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                      const Icon(
                        Icons.email_outlined,
                        size: 100,
                        color: Colors.redAccent,
                      ),
                      const Text(
                        'EsmpShop@gmail.com',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.redAccent,
                        ),
                      )
                    ]),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
