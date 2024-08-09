import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ui_w2/config/config.dart';
import 'package:flutter_ui_w2/config/internal_config.dart';
import 'package:flutter_ui_w2/models/request/customerLoginPostReq.dart';
import 'package:flutter_ui_w2/models/response/customersLoginPostRes.dart';
import 'package:flutter_ui_w2/pages/register.dart';
import 'package:flutter_ui_w2/pages/showtrip.dart';

import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int count = 0;
  String phoneNo = '';
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  String url = '';

  // InitState คือ Function ที่ทำงานเมื่อเปิดหน้านี้
  // 1. InitState จะทำงาน "ครั้งเดียว" เมื่อเปิดหน้านี้
  // 2. มันจะไม่ทำงานอีกเมื่อเราเรียก setState
  // 3. มันไม่สามารถทำงานเป็น async  function ได้
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    log("onDoubleTap is fired");
                  },
                  child: Image.asset(
                    'assets/images/logo.png',
                  )),
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('หมายเลขโทรศัพท์',
                        style: TextStyle(
                          fontSize: 24,
                        )),
                    TextField(
                        controller: phoneCtl,
                        // onChanged: (value) {
                        //   phoneNo = value;
                        // },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1)))),
                    const Text('รหัสผ่าน',
                        style: TextStyle(
                          fontSize: 24,
                        )),
                    TextField(
                        controller: passwordCtl,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1)))),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () => register(),
                      child: const Text('ลงทะเบียนใหม่',
                          style: TextStyle(
                            fontSize: 18,
                          ))),
                  FilledButton(
                      onPressed: login,
                      child: const Text('เข้าสู่ระบบ',
                          style: TextStyle(
                            fontSize: 18,
                          ))),
                ],
              ),
              Text(text)
            ],
          ),
        ));
  }

  void login() async {
    // var data = {"phone": "0817399999", "password": "1111"};
    var data = CustomersLoginPostRequest(
        phone: phoneCtl.text, password: passwordCtl.text);
    try {
      var value = await http.post(
          Uri.parse("$url/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customersLoginPostRequestToJson(data));
      CustomersLoginPostResponse customer =
          customersLoginPostResponseFromJson(value.body);
      log(customer.customer.email);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowTripPage(idx: customer.customer.idx),
          ));
    } catch (eeee) {
      setState(() {
        text = 'phone no or password incorrect';
      });
    }

    // void login() {
    //   // var data = {"phone": "0817399999", "password": "1111"};
    //   var data = CustomersLoginPostRequest(
    //       phone: phoneCtl.text, password: passwordCtl.text);
    //   http
    //       .post(Uri.parse("http://10.34.40.42:3000/customers/login"),
    //           headers: {"Content-Type": "application/json; charset=utf-8"},
    //           body: customersLoginPostRequestToJson(data))
    //       .then(
    //     (value) {
    //       CustomersLoginPostResponse customer =
    //           customersLoginPostResponseFromJson(value.body);
    //       log(customer.customer.email);
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => const ShowTripPage(),
    //           ));
    //       // var jsonRes = jsonDecode(value.body);
    //       // log(jsonRes['customer']['email']);
    //     },
    //   ).catchError((error) {
    //     setState(() {
    //       text = 'phone no or password incorrect';
    //     });
    //     log('Error $error');
    //   });

    // if (customer.email == data.phone && passwordCtl.text == data.password) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const ShowTripPage(),
    //       ));
    // } else {
    //   setState(() {
    //     text = 'phone no or password incorrect';
    //   });
    // }
  }

  void register() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
    // log('This is Register button');
    // text = 'Hello world!!!';
  }
}
