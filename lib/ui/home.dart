import 'dart:ui';

import 'package:barcode_scan_app/constants.dart';
import 'package:barcode_scan_app/db/database_helper.dart';
import 'package:barcode_scan_app/ui/generate_barcode.dart';
import 'package:barcode_scan_app/ui/notes.dart';
import 'package:barcode_scan_app/ui/students.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbHelper = DatabaseHelper.instance;

  Future<int> addNote(String timeStamp, int studentId, String name, String passcode) async {
    Map<String, dynamic> row = {
      'wagt': timeStamp,
      'ady': name,
      'barkod': passcode,
      'talyp_id': studentId,
    };
    return await dbHelper.insert1(row);
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode('#FF7D54', 'Cancel', true, ScanMode.BARCODE);
      if (barcodeScanRes != "-1") {
        String date = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now());

        dbHelper.queryByCode(barcodeScanRes).then((value) {
          if (value != null) {
            if (value.isNotEmpty) {
              for (var element in value) {
                addNote(date, element[DatabaseHelper.columnId], element[DatabaseHelper.columnName],
                        barcodeScanRes)
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                      backgroundColor: primaryColor_1,
                      duration: const Duration(seconds: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      behavior: SnackBarBehavior.floating,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      content: ListTile(
                        trailing: Lottie.asset("assets/lottie/success.json"),
                        textColor: Colors.white,
                        title: Text(
                          element[DatabaseHelper.columnName],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          barcodeScanRes,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                      )));
                });
              }
            } else if (value.isEmpty) {
              showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                        title: Lottie.asset("assets/lottie/error.json", width: 100, height: 80),
                        content: const Text(
                          'No student with this \nbarcode was found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Rubik",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.systemGrey),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Add student'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => AddStudent(
                                        barcode: barcodeScanRes,
                                      )));
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ));
            }
          }
        }).whenComplete(() => setState(() {}));
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor_3,
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: primaryColor_3,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: primaryColor_3, statusBarBrightness: Brightness.light)),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              )),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            children: [
              GridView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 3 / 3,
                    crossAxisCount: 2),
                children: [
                  InkWell(
                    onTap: () {
                      scanBarcodeNormal();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: primaryColor_1,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.fromBorderSide(BorderSide(color: primaryColor_1, width: 2)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            IconlyBroken.scan,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            "Scan Barcode",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) => const Students()));
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: primaryColor_1,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.fromBorderSide(BorderSide(color: primaryColor_1, width: 2)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            IconlyBroken.user3,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            "Students",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          fullscreenDialog: true,
                          title: "AllNotes",
                          builder: (context) => const AllNotes()));
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: primaryColor_1,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.fromBorderSide(BorderSide(color: primaryColor_1, width: 2)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            IconlyBroken.calendar,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            "All Notes",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          fullscreenDialog: true, builder: (context) => const AddStudent()));
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: primaryColor_1,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.fromBorderSide(BorderSide(color: primaryColor_1, width: 2)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            IconlyBroken.document,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            "Generate Barcode",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Today",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                  future: Future.delayed(
                      const Duration(seconds: 1),
                      () => dbHelper.queryAllRows1(
                          sort: 'DESC',
                          query: '${DateFormat('dd-MM-yyyy').format(DateTime.now())}')),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      //   final text = "wwfefse".substring(start);
                      if (snapshot.data!.isEmpty) {
                        return SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/lottie/empty_today.json',
                                    height: 150, width: 150),
                                const SizedBox(height: 20),
                                Text(
                                  'No students have been \nregistered so far',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade500),
                                )
                              ],
                            ));
                      } else {
                        return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: primaryColor_4,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ListTile(
                                  minVerticalPadding: 25,
                                  subtitle: Text(
                                      snapshot.data![index]['wagt'].split(" ")[1].substring(0, 5)),
                                  tileColor: primaryColor_4,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  onTap: () {},
                                  leading: BarcodeWidget(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    backgroundColor: Colors.white,
                                    height: 40,
                                    width: 40,
                                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    padding: const EdgeInsets.all(5.0),
                                    barcode: Barcode.code128(),
                                    data: snapshot.data![index]['barkod'].toString(),
                                    style: const TextStyle(fontSize: 5),
                                  ),
                                  title: Text(snapshot.data![index]['ady'].toString()),
                                  trailing: const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                                const Divider(color: Colors.white, height: 5));
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator(color: primaryColor_1));
                    }
                  }),
            ],
          ),
        ));
  }
}
