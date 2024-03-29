// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print

import '../components/contants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

typedef OnChangeCallback = void Function(dynamic value);

class CodeTest extends StatefulWidget {
  final OnChangeCallback code;
  final int check_property;
  const CodeTest({
    Key? key,
    required this.code,
    this.cd,
    required this.check_property,
  }) : super(key: key);
  final String? cd;
  @override
  State<CodeTest> createState() => _CodeTestState();
}

class _CodeTestState extends State<CodeTest> {
  late List code;
  bool loading = false;
  late int codedisplay;
  @override
  void initState() {
    if (widget.check_property == 1) {
      Load1();
    }
    if (widget.check_property == 2) {
      Load2();
    }
    code = [];
    codedisplay = 0;
    super.initState();
  }

  void Load1() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/getsearchpublish?search_publish=0'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      setState(() {
        loading = false;
        code = jsonData;
        codedisplay = int.parse(code[0]['search']) + 1;
        print(code[0]['search']);
        widget.code(codedisplay);
        print(codedisplay);
      });
    }
  }

  void Load2() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/getsearchpublish?search_publish=0'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);

      setState(() {
        loading = false;
        code = jsonData;
        codedisplay = int.parse(code[0]['search'].toString()) + 1;
        widget.code(codedisplay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: loading
          ? Center(child: CircularProgressIndicator())
          : //if loading == true, show progress indicator
          Row(
              children: [
                SizedBox(width: 40),
                Icon(
                  Icons.qr_code,
                  color: kImageColor,
                  size: 30,
                ),
                SizedBox(width: 10),
                ((widget.cd == null)
                    ? Text(
                        codedisplay.toString(),
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor),
                      )
                    : Text(
                        widget.cd.toString(),
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor),
                      )),
              ],
            ),
    );
  }
}
