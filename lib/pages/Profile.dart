import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_ui_w2/config/config.dart';
import 'package:flutter_ui_w2/models/response/customerIdxGetRes.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  int idx = 0;
  ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

var fullnameCtl = TextEditingController();
var phoneCtl = TextEditingController();
var emailCtl = TextEditingController();
var imageCtl = TextEditingController();

class _ProfilePageState extends State<ProfilePage> {
  late CustomerIdxGetResponse customer;
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    // 4. assign loadData
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'ยืนยันการยกเลิกสมาชิก?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('ปิด')),
                          FilledButton(
                              onPressed: delete, child: const Text('ยืนยัน'))
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
          future: loadDataAsync(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            fullnameCtl.text = customer.fullname;
            phoneCtl.text = customer.phone;
            emailCtl.text = customer.email;
            imageCtl.text = customer.image;
            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(width: 200, child: Image.network(customer.image)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ชื่อ - นามสกุล'),
                          TextField(
                            controller: fullnameCtl,
                          ),
                          const Text('หมายเลขโทรศัพท์'),
                          TextField(
                            controller: phoneCtl,
                          ),
                          const Text('อีเมล'),
                          TextField(
                            controller: emailCtl,
                          ),
                          const Text('รูปภาพ'),
                          TextField(
                            controller: imageCtl,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                          onPressed: update,
                          child: const Text('บันทึกข้อมูล',
                              style: TextStyle(
                                fontSize: 18,
                              ))),
                    ),
                  ],
                ),
              ),
            );
            // return Text(customer.fullname);
          }),
    );
  }

  void delete() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var res = await http.delete(Uri.parse('$url/customers/${widget.idx}'));
    log(res.statusCode.toString());
    
    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: Text('ลบข้อมูลสำเร็จ'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text('ปิด'))
          ],
        ),
      ).then((s) {
        Navigator.popUntil(
          context,
          (route) => route.isFirst,
        );
      });
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('ลบข้อมูลไม่สำเร็จ'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }

  }

  void update() async {
    var json = {
      "fullname": fullnameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": emailCtl.text
    };

    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    try {
      var data = await http.put(Uri.parse('$url/customers/${widget.idx}'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(json));
      log(data.body);

      var result = jsonDecode(data.body);
      log(result['message']);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('บันทึกข้อมูลไม่สำเร็จ ' + err.toString()),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    log(res.body);
    customer = customerIdxGetResponseFromJson(res.body);
  }
}
