// ignore_for_file: unused_field, unused_local_variable

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kfa_admin/interface/mobile/navigate_home/User/search.dart';
import '../../../../components/contants.dart';

class User_Vpoint extends StatefulWidget {
  const User_Vpoint({super.key});

  @override
  State<User_Vpoint> createState() => _Uer_VpointState();
}

class _Uer_VpointState extends State<User_Vpoint> {
  @override
  void initState() {
    User_VPoint();
    super.initState();
  }

  int index_back = 0;
  bool callback = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: MediaQuery.of(context).size.height * 0.04,
            )),
        backgroundColor: Color.fromARGB(255, 23, 17, 124),
        actions: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.55,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextFormField(
                    onTap: () async {
                      final selected = await showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(list,
                            //  (value) {
                            //   setState(() {
                            //     // list_back = value;
                            //     print(value.toString());
                            //   });
                            // },
                            (value) {
                          setState(() {
                            callback = true;
                            index_back = int.parse(value.toString());
                            print(index_back.toString());
                          });
                        }),
                      );
                      if (selected != null) {
                        // Handle the selected item here.
                        print('Selected: $selected');
                      }
                    },
                    readOnly: true,
                    // onChanged: (value) {
                    //   setState(() {
                    //     // query = value;
                    //     // _search(query);
                    //   });
                    // },
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: 'Search listing here...',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              GFButton(
                textStyle: TextStyle(color: Colors.white),
                onPressed: () async {
                  setState(() {
                    callback = false;
                  });
                },
                text: "All",
                icon: Icon(Icons.menu_open),
                color: Colors.white,
                type: GFButtonType.outline,
              ),
              SizedBox(width: 10)
            ],
          ),
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Color.fromARGB(255, 23, 17, 124),
      body: callback == false ? body(list, 0) : body(list, index_back),
    );
  }

  Widget body(List list, index_back) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 220, 223, 223),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      child: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: double.infinity,
        child: ListView.builder(
          itemCount: (callback != false) ? 1 : list.length,
          itemBuilder: (context, index) {
            return (callback != false)
                // ?
                ? Box_value(list, index_back)
                // _Text('sdfsdf')
                : Box_value(list, index);
          },
        ),
      )),
    );
  }

  Widget Box_value(list, index) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.17,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Text(
                      'User ID : ${(list[index]['id_user_control'].toString() == "null") ? "" : list[index]['id_user_control']}'),
                  _Text(
                      'Name : ${list[index]['first_name']} ${list[index]['last_name']}'),
                  _Text('Sex : ${list[index]['gender']}'),
                  _Text('Phone : ${list[index]['tel_num']}'),
                  _Text('Email : ${list[index]['email']}'),
                  V_Image(
                      '${(list[index]['count_autoverbal'].toString() == "null") ? "0" : list[index]['count_autoverbal']}'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GFButton(
                    textStyle:
                        TextStyle(color: Color.fromARGB(255, 148, 146, 146)),
                    onPressed: () {
                      setState(() {
                        _showMyDialog(
                            'User ID : ${(list[index]['id_user_control'].toString() == "null") ? "" : list[index]['id_user_control']}',
                            'Name : ${list[index]['first_name']} ${list[index]['last_name']}',
                            'Sex : ${list[index]['gender']}',
                            'Phone : ${list[index]['tel_num']}',
                            'Email : ${list[index]['email']}',
                            '${(list[index]['count_autoverbal'].toString() == "null") ? "0" : list[index]['count_autoverbal']}',
                            '${(list[index]['id_user_control'].toString() == "null") ? "" : list[index]['id_user_control']}');
                        _v_point = TextEditingController(
                            text:
                                '${(list[index]['count_autoverbal'].toString() == "null") ? "0" : list[index]['count_autoverbal']}');
                        // Edit_V_Point('${list[index]['id_user_control']}',
                        //     '${list[index]['count_autoverbal']}');
                      });
                    },
                    text: "Edit",
                    icon: Icon(Icons.edit),
                    color: Color.fromARGB(255, 204, 203, 203),
                    type: GFButtonType.outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget V_Image(v_point) {
    return Row(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.02,
          width: MediaQuery.of(context).size.height * 0.02,
          child: Image.network(
              'https://www.oneclickonedollar.com/laravel_kfa_2023/public/data_imgs_kfa/Form_Image/v.png'),
        ),
        Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.02,
            width: MediaQuery.of(context).size.height * 0.08,
            child: _Text('$v_point')),
      ],
    );
  }

  Future<void> Edit_V_Point(id_user_control) async {
    var count_autoverbal;
    // var id = '38K622F38A';
    setState(() {
      count_autoverbal = _v_point!.text;
      print(count_autoverbal.toString());
    });

    Map<String, dynamic> payload = await {
      // "id_user_control": '81K564F81A',
      // "count_autoverbal": '44',
      "id_user_control": id_user_control.toString(),
      "count_autoverbal": count_autoverbal.toString(),
    };
    final url = await Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/updart_count_VP');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      print('Success');
      AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: false,
          title: 'Succesfully',
          autoHide: Duration(seconds: 3),
          onDismissCallback: (type) {
            setState(() {});
            Navigator.pop(context);
          }).show();
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  }

  Widget _Text(text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.grey[700],
            fontSize: MediaQuery.textScaleFactorOf(context) * 10),
      ),
    );
  }

  Future<void> _showMyDialog(text, name, sex, phone, email, v_point, id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Text(text),
              InkWell(
                onTap: () {
                  setState(() {
                    Edit_V_Point(id);
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width * 0.16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 2,
                      color: Color.fromARGB(255, 58, 59, 60),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.download),
                      Text(
                        'Save',
                        style: TextStyle(
                            color: Color.fromARGB(255, 56, 55, 55),
                            fontSize:
                                MediaQuery.textScaleFactorOf(context) * 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Text(name),
              _Text(sex),
              _Text(phone),
              _Text(email),
              SizedBox(height: 10),
              Input_V(),
            ],
          )),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back',
                  style: TextStyle(color: Colors.grey),
                ))
          ],
        );
      },
    );
  }

  TextEditingController? _v_point;
  String? v_point;
  Widget Input_V() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.04,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.035,
            width: MediaQuery.of(context).size.height * 0.035,
            child: Image.network(
                'https://www.oneclickonedollar.com/laravel_kfa_2023/public/data_imgs_kfa/Form_Image/v.png'),
          ),
          SizedBox(width: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: TextFormField(
                controller: _v_point,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    v_point = value;
                  });
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),

                  // hintText: '$text',
                  fillColor: kwhite,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List list = [];
  Future<void> User_VPoint() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/user_VPoint'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body);
        list = jsonBody;
        setState(() {
          list;
        });
      } else {
        print('Error');
      }
    } catch (e) {
      print('Error $e');
    }
  }
}
