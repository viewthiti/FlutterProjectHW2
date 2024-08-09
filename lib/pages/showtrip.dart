import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ui_w2/config/config.dart';
import 'package:flutter_ui_w2/models/response/tripsGetRes.dart';
import 'package:flutter_ui_w2/pages/login.dart';
import 'package:flutter_ui_w2/pages/profile.dart';
import 'package:flutter_ui_w2/pages/trip.dart';
import 'package:http/http.dart' as http;

class ShowTripPage extends StatefulWidget {
  int idx = 0;
  ShowTripPage({super.key, required this.idx});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripsGetResponse> trips = [];

  //3. use loadDataAsync()
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
        title: Text('รายการทริป'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(idx: widget.idx)));
              } else if (value == 'logout') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ปลายทาง',
                style: TextStyle(
                  fontSize: 16,
                )),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilledButton(
                      onPressed: () => getTrips(null),
                      child: const Text('ทั้งหมด')),
                  const SizedBox(
                    width: 8,
                  ),
                  FilledButton(
                      onPressed: () => getTrips('เอเชียตะวันออกเฉียงใต้'),
                      child: const Text('เอเชียตะวันออกเฉียงใต้')),
                  const SizedBox(
                    width: 8,
                  ),
                  FilledButton(
                      onPressed: () => getTrips('ยุโรป'),
                      child: const Text('ยุโรป')),
                  const SizedBox(
                    width: 8,
                  ),
                  FilledButton(
                      onPressed: () => getTrips('อาเซียน'),
                      child: const Text('อาเซียน')),
                  const SizedBox(
                    width: 8,
                  ),
                  FilledButton(
                      onPressed: () => getTrips('เอเชีย'),
                      child: const Text('เอเชีย')),
                  const SizedBox(
                    width: 8,
                  ),
                  FilledButton(
                      onPressed: () => getTrips('ประเทศไทย'),
                      child: const Text('ประเทศไทย')),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child:
                    // 1. creat feturebulider
                    FutureBuilder(
                        future: loadData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return Column(
                              children: trips
                                  .map(
                                    (trip) => Card(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (trip.name),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 160,
                                              height: 160,
                                              child: Image.network(
                                                trip.coverimage,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Center(
                                                    child: Text(
                                                      'cannot load image',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'ประเทศ ${trip.country}'),
                                                  Text(
                                                      'ระยะเวลา ${trip.duration} วัน'),
                                                  Text(
                                                      'ราคา ${trip.price} บาท'),
                                                  FilledButton(
                                                      onPressed: () =>
                                                          goToTripPage(
                                                              trip.idx),
                                                      child: const Text(
                                                          'รายละเอียดเพิ่มเติม')),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                  )
                                  .toList());
                        }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. (async) Function for loading data from api
  Future<void> loadDataAsync() async {
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];

    var data = await http.get(Uri.parse('$url/trips'));
    trips = tripsGetResponseFromJson(data.body);
  }

  void getTrips(String? zone) {
    http.get(Uri.parse('$url/trips')).then(
      (value) {
        trips = tripsGetResponseFromJson(value.body);
        List<TripsGetResponse> filteredTrips = [];
        if (zone != null) {
          for (var trip in trips) {
            if (trip.destinationZone == zone) {
              filteredTrips.add(trip);
            }
          }
          trips = filteredTrips;
        }
        setState(() {});
      },
    ).catchError((err) {
      log(err.toString());
    });
  }

  goToTripPage(int idx) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TripPage(idx: idx)));
  }
}
