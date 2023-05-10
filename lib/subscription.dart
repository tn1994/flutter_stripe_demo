import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> welcomeFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String welcomeToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));

class StripeModel {
  // https://kimuralog.com/?p=2283
  // https://zenn.dev/iwaku/articles/2020-12-29-iwaku

  static Future<String> getProducts() async {
    // https://isub.co.jp/flutter/flutter-http-api/
    final url = Uri.parse('http://localhost:8080/products');
    http.Response resp = await http.get(url);
    return json.decode(resp.body)['data'].toString();
  }
}

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription'),
      ),
      body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            Text('Welcome!!'),

            // Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     // これで両端に寄せる
            //     children: [
            //       FloatingActionButton(
            //         child: Icon(
            //           Icons.arrow_left,
            //           color: Colors.white,
            //         ),
            //         shape: CircleBorder(),
            //         onPressed: () {
            //           Navigator.pop(
            //             context,
            //           );
            //         },
            //       ),
            //     ]),
          ])),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
            context,
          );
        },
        tooltip: 'nav back',
        child: const Icon(
          Icons.arrow_left,
        ),
      ), // This
    );
  }
}

class DetailPage extends StatelessWidget {
  // https://qiita.com/rei_012/items/de47f84f25c5067b3c9d
  // https://flutter.gakumon.jp/entry/flutter-textfield
  // https://fonts.google.com/icons?selected=Material+Icons:account_circle:

  // https://b1san-blog.com/post/flutter/flutter-text-field/
  //Controllerの定義
  final controller = TextEditingController();

  //Controllerから値の取得
  // String _message = controller.text;

  void getProducts() async {
    debugPrint('start getProducts');
    var res = await StripeModel.getProducts();
    debugPrint(res);
  }

  bool check() {
    if (controller.text.isNotEmpty) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Subscription'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign Up'),
                  //Controllerの設定
                  TextField(
                    maxLength: 16,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.account_circle),
                      hintText: "例) 田中 太郎",
                      labelText: "Name",
                    ),
                    controller: controller,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    IconButton(
                        onPressed: () async {
                          // getProducts();

                          var res = await StripeModel.getProducts();
                          debugPrint(res);

                          if (check()) {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  // transitionDuration: Duration(milliseconds: 500),
                                  pageBuilder: (_, __, ___) => SignIn(),
                                ));
                          }
                        },
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        )),
                  ]),
                ],
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // これで両端に寄せる
                children: [
                  FloatingActionButton(
                    child: Icon(
                      Icons.arrow_left,
                      color: Colors.white,
                    ),
                    shape: CircleBorder(),
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                ])
          ],
        )));
  }
}

class SubscriptionState extends State<Subscription> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // https://yakiimosan.com/flutter-card/
    return SizedBox(
        height: 50,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Card(
                  color: Colors.blue.withOpacity(0.8),
                  elevation: 10,
                  shadowColor: Colors.black,
                  child: SizedBox(
                    width: 275,
                    height: 80,
                    child: Center(child: Text('Pro')),
                  ),
                ),
                onTap: () {
                  debugPrint('click pro');
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) => DetailPage(),
                      ));
                },
              ),
              GestureDetector(
                child: Card(
                  color: Color(0xffcce3f3),
                  // color: Colors.blue.withOpacity(0.3),
                  elevation: 10,
                  shadowColor: Colors.black,
                  child: SizedBox(
                    width: 275,
                    height: 80,
                    child: Center(child: Text('Standard')),
                  ),
                ),
                onTap: () {
                  debugPrint('click standard');
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) => DetailPage(),
                      ));
                },
              ),
            ],
          ),
        ));
  }
}

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  SubscriptionState createState() => SubscriptionState();
}
