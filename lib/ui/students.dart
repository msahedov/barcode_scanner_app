import 'package:barcode_scan_app/constants.dart';
import 'package:barcode_scan_app/db/database_helper.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class Students extends StatefulWidget {
  const Students({Key? key}) : super(key: key);

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  final dbHelper = DatabaseHelper.instance;
  String _sort = "ASC";
  String _query = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor_3,
        appBar: AppBar(
            bottom: PreferredSize(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
                  child: CupertinoSearchTextField(
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        _query = value;
                      });
                    },
                  ),
                ),
                preferredSize: const Size.fromHeight(50)),
            actions: [
              IconButton(
                icon: Icon(
                  _sort == "ASC"
                      ? CupertinoIcons.sort_up
                      : CupertinoIcons.sort_down, //IconlyLight.filter2,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  if (_sort == "ASC") {
                    setState(() {
                      _sort = "DESC";
                    });
                  } else {
                    setState(() {
                      _sort = "ASC";
                    });
                  }
                },
              ),
              const SizedBox(
                width: 5,
              ),
            ],
            elevation: 0.0,
            title: const Text(
              'Students',
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
            backgroundColor: primaryColor_3,
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
              future: Future.delayed(const Duration(seconds: 1),
                  () => dbHelper.queryAllRows(sort: _sort, query: _query)),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Column(
                            children: [
                              Lottie.asset('assets/lottie/empty.json', height: 150, width: 150),
                              Text(
                                'No Students',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade400),
                              )
                            ],
                          )),
                    );
                  } else {
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: primaryColor_4,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ListTile(
                            isThreeLine: true,
                            onTap: () {
                              Navigator.of(context)
                                  .push<bool>(
                                CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => StudentDetails(
                                    end: '${snapshot.data![index][DatabaseHelper.columnEnd]}',
                                    faculty:
                                        '${snapshot.data![index][DatabaseHelper.columnFaculty]}',
                                    group: '${snapshot.data![index][DatabaseHelper.columnGroup]}',
                                    id: '${snapshot.data![index][DatabaseHelper.columnId]}',
                                    name: '${snapshot.data![index][DatabaseHelper.columnName]}',
                                    passcode:
                                        '${snapshot.data![index][DatabaseHelper.columnPassCode]}',
                                    start: '${snapshot.data![index][DatabaseHelper.columnStart]}',
                                  ),
                                ),
                              )
                                  .then((value) {
                                if (value != null) {
                                  setState(() {});
                                }
                              });
                            },
                            minVerticalPadding: 25,
                            leading: const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: ImageIcon(
                                AssetImage("assets/icons/student1.png"),
                                size: 45,
                              ),
                            ),
                            title: Text('${snapshot.data![index][DatabaseHelper.columnName]}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                            //trailing: Text("3"),s

                            subtitle: Text(
                              '${snapshot.data![index][DatabaseHelper.columnFaculty]}\n${snapshot.data![index][DatabaseHelper.columnGroup]}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data?.length ?? 0,
                      separatorBuilder: (BuildContext context, int index) => const Divider(
                        height: 10,
                        color: Colors.white,
                      ),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator(color: primaryColor_1));
                }
              }),
        ));
  }
}

class StudentDetails extends StatelessWidget {
  StudentDetails(
      {Key? key,
      required this.id,
      required this.name,
      required this.faculty,
      required this.group,
      required this.passcode,
      required this.start,
      required this.end})
      : super(key: key);
  final String id;
  final String name;
  final String faculty;
  final String group;
  final String passcode;
  final String start;
  final String end;
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor_3,
        appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(
                  CupertinoIcons.delete, //IconlyLight.filter2,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                            title: const Text('Delete student'),
                            content: const Text('Are you sure you want to delete this student?'),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              CupertinoDialogAction(
                                child: const Text('Delete'),
                                onPressed: () {
                                  dbHelper.delete(int.parse(id));
                                  Navigator.of(context).pop(true);
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          ));
                  // dbHelper.deleteRow(id);
                  // Navigator.pop(context);
                },
              ),
              const SizedBox(
                width: 5,
              ),
            ],
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(CupertinoIcons.arrow_left),
            ),
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
              const SizedBox(height: 20),
              BarcodeWidget(
                backgroundColor: Colors.white,
                height: 100,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: const EdgeInsets.all(5.0),
                barcode: Barcode.code128(),
                data: passcode,
                style: const TextStyle(fontSize: 16, overflow: TextOverflow.clip),
              ),
              const SizedBox(height: 30),
              TextFormField(
                enabled: false,
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                enabled: false,
                initialValue: faculty,
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'Please enter faculty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Faculty',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                enabled: false,
                initialValue: group,
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'Please enter group';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Group',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                enabled: false,
                initialValue: passcode,
                decoration: const InputDecoration(
                  labelText: 'Pass code',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        enabled: false,
                        initialValue: start,
                        keyboardType: TextInputType.number,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Please enter start year';
                          }
                          return null;
                        },
                        inputFormatters: [LengthLimitingTextInputFormatter(4)],
                        decoration: const InputDecoration(
                          focusColor: primaryColor_1,
                          hoverColor: primaryColor_1,
                          labelText: 'Start date',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: end,
                        enabled: false,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Please enter end year';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(4)],
                        decoration: const InputDecoration(
                          labelText: 'End date',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ]),
              // const SizedBox(height: 30),
              // RaisedButton(
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              //     color: primaryColor_1,
              //     onPressed: () {
              //       // if (_formKey.currentState!.validate()) {
              //       //   _formKey.currentState!.reset();
              //       //   addStudent(_name.text, _faculty.text, _group.text, _passcode.text,
              //       //           _start.text, _end.text)
              //       //       .then((value) {
              //       //     print(value);
              //       //     if (value != -1) {
              //       //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //       //           //margin: EdgeInsets.fromLTRB(10, 0, 10, 30),
              //       //           backgroundColor: primaryColor_1.withOpacity(0.5),
              //       //           duration: Duration(seconds: 1),
              //       //           elevation: 0.0,
              //       //           padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              //       //           behavior: SnackBarBehavior.floating,
              //       //           shape: RoundedRectangleBorder(
              //       //               borderRadius: BorderRadius.all(Radius.circular(25))),
              //       //           content: ListTile(
              //       //             leading: Icon(
              //       //               Icons.check_circle,
              //       //               color: Colors.green,
              //       //               size: 40,
              //       //             ),
              //       //             textColor: Colors.white,
              //       //             title: Text('Added successfully'),
              //       //           )));
              //       //     }
              //       //   });
              //       // }
              //     },
              //     textColor: Colors.white,
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     child: const Text('Add')),
            ],
          ),
        ));
  }
}
