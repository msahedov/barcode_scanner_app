import 'package:barcode_scan_app/constants.dart';
import 'package:barcode_scan_app/db/database_helper.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor_3,
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: primaryColor_3,
            title: const Text(
              'Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(CupertinoIcons.arrow_left),
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: primaryColor_3, statusBarBrightness: Brightness.light)),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              )),
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: Future.delayed(
                  const Duration(seconds: 1), () => dbHelper.queryAllRows1(sort: "DESC")),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/lottie/empty_today.json', height: 200, width: 200),
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
                    return Scrollbar(
                        showTrackOnHover: true,
                        isAlwaysShown: true,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              decoration: const BoxDecoration(
                                color: primaryColor_4,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: ListTile(
                                minVerticalPadding: 25,
                                subtitle: Text(snapshot.data![index]['wagt'].toString()),
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
                              const Divider(color: Colors.white, height: 5),
                        ));
                  }
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: primaryColor_1,
                  ));
                }
              }),
        ));
  }
}
