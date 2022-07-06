import 'package:barcode_scan_app/constants.dart';
import 'package:barcode_scan_app/db/database_helper.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key, this.barcode}) : super(key: key);
  final String? barcode;
  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _faculty = TextEditingController();
  final TextEditingController _group = TextEditingController();
  TextEditingController? _passcode;
  final TextEditingController _start = TextEditingController();
  final TextEditingController _end = TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  Future<int> addStudent(
      String name, String faculty, String group, String passcode, String start, String end) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnFaculty: faculty,
      DatabaseHelper.columnGroup: group,
      DatabaseHelper.columnPassCode: passcode,
      DatabaseHelper.columnStart: start,
      DatabaseHelper.columnEnd: end,
    };
    return await dbHelper.insert(row);
  }

  @override
  void initState() {
    _passcode = TextEditingController(text: widget.barcode != null ? widget.barcode : '');
    super.initState();
  }

  void reset() {
    setState(() {
      _name.clear();
      _faculty.clear();
      _passcode?.clear();
      _group.clear();
      _start.clear();
      _end.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor_3,
        appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: const Text(
              'Add student',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
          child: Form(
            key: _formKey,
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
                  data: _passcode?.text ?? '',
                  style: const TextStyle(fontSize: 16, overflow: TextOverflow.clip),
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter student name';
                    }
                    return null;
                  },
                  controller: _name,
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
                  keyboardType: TextInputType.text,
                  controller: _faculty,
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
                  keyboardType: TextInputType.text,
                  controller: _group,
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
                  keyboardType: TextInputType.text,
                  controller: _passcode,
                  onChanged: (text) => setState(() {}),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return 'Please enter passcode';
                    }
                    return null;
                  },
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
                          controller: _start,
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
                          controller: _end,
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
                const SizedBox(height: 30),
                RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    color: primaryColor_1,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  title: Lottie.asset(
                                    'assets/lottie/loader1.json',
                                    width: 100,
                                    height: 60,
                                  ),
                                  content: const Text(
                                    'Please wait...',
                                    style: TextStyle(
                                        fontFamily: "Rubik",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.systemGrey),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      isDestructiveAction: true,
                                      child: const Icon(
                                        CupertinoIcons.clear_circled,
                                        size: 30,
                                        color: primaryColor_1,
                                      ), //const Text('Cancel'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ));

                        Future.delayed(const Duration(seconds: 3), () async {
                          Navigator.pop(context);
                          await dbHelper.queryAllRows().then((rows) {
                            if (rows.isEmpty) {
                              addStudent(_name.text, _faculty.text, _group.text,
                                  _passcode?.text ?? '', _start.text, _end.text);
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        title: Lottie.asset("assets/lottie/success.json",
                                            width: 100, height: 60),
                                        content: const Text(
                                          'Successfully added',
                                          style: TextStyle(
                                              fontFamily: "Rubik",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: CupertinoColors.systemGrey),
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            isDestructiveAction: true,
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                  fontFamily: "Rubik",
                                                  color: primaryColor_1,
                                                  fontSize: 16),
                                            ),
                                            onPressed: () {
                                              reset();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ));
                            } else {
                              for (var row in rows) {
                                if (row[DatabaseHelper.columnPassCode] == _passcode?.text) {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) => CupertinoAlertDialog(
                                            title: Lottie.asset("assets/lottie/error.json",
                                                width: 100, height: 60),
                                            content: const Text(
                                              'Passcode already exists',
                                              style: TextStyle(
                                                  fontFamily: "Rubik",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: CupertinoColors.systemGrey),
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                isDefaultAction: true,
                                                isDestructiveAction: true,
                                                child: const Icon(
                                                  CupertinoIcons.clear_circled,
                                                  size: 30,
                                                  color: primaryColor_1,
                                                ), //const Text('Cancel'),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                            ],
                                          ));
                                  return;
                                }
                              }
                              addStudent(_name.text, _faculty.text, _group.text,
                                  _passcode?.text ?? '', _start.text, _end.text);
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        title: Lottie.asset("assets/lottie/success.json",
                                            width: 100, height: 60),
                                        content: const Text(
                                          'Successfully added',
                                          style: TextStyle(
                                              fontFamily: "Rubik",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: CupertinoColors.systemGrey),
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            isDestructiveAction: true,
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                  fontFamily: "Rubik",
                                                  color: primaryColor_1,
                                                  fontSize: 16),
                                            ),
                                            onPressed: () {
                                              reset();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ));
                            }
                          });
                        });
                      }
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text('Add')),
              ],
            ),
          ),
        ));
  }
}
