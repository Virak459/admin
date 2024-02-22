// ignore_for_file: unused_element, unused_local_variable, unused_field, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:getwidget/components/animation/gf_animation.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_animation_type.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../components/L_w_total.dart';
import '../../../../components/contants.dart';
import '../../../../model/executive/buiding_executive.dart';
import '../../../../model/executive/executive.dart';
import '../../../../server/api_service.dart';
import 'google_map/google_map.dart';
import 'land_building/LandBuilding.dart';
import 'land_building/landbuilding_appraiser.dart';

class New_Executive extends StatefulWidget {
  const New_Executive({super.key});

  @override
  State<New_Executive> createState() => _New_ExecutiveState();
}

class _New_ExecutiveState extends State<New_Executive>
    with SingleTickerProviderStateMixin {
  TextEditingController fromdate = TextEditingController();
  TextEditingController Valuation = TextEditingController();
  TextEditingController Issue = TextEditingController();
  TextEditingController todate = TextEditingController();
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    frist_switch = 'one';
    // switchValues = List<bool>.generate(list_map.length, (index) => false);
    requestModelbuildng = BuildingRequestModel(
        executive_id: 0,
        executiveStatus: 1,
        executive_address: '',
        executive_app: 0,
        executive_approvel: 0,
        executive_building: '',
        executive_by: 0,
        executive_com: 0,
        executive_comment: '',
        executive_commune_id: 0,
        executive_create_by: 0,
        executive_customer_id: 0,
        executive_district_id: 0,
        executive_fair: '',
        executive_fire: '',
        executive_forced: '',
        executive_land_lengh: '',
        executive_land_price: '',
        executive_land_price_per: '',
        executive_land_total: '',
        executive_land_width: '',
        executive_lng: '',
        executive_lon: '',
        executive_market_max: '',
        executive_market_min: '',
        executive_modify_by: 0,
        executive_modify_date: '',
        executive_name: 0,
        executive_obligation: '',
        executive_property_name: '',
        executive_property_type_id: 0,
        executive_province_id: 0,
        executive_published: 1,
        executive_purpose: '',
        executive_remark: '',
        executive_remarks: '',
        executive_road_type_id: 0,
        executive_user: '',
        executive_valuate_id: 0,
        executive_valuation_date: '',
        executive_valuation_issue_date: '',
        executive_zone_id: 0,
        executiveapprove1status: 0,
        executivestatusid: 1,
        remember_token: '',
        building: [],
        appriaser: [],
        conparable_map: []
        // autoVerbal: [requestModelVerbal],
        // data: requestModelVerbal,
        );
    _Customer_name();
    _hometype();
    last_id();
    zoning();
    _road();
    today_formart();
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 645), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.repeat();
    offsetAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: const Offset(0, -0.3),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    ));
  }

  late BuildingRequestModel requestModelbuildng;
  String? reloard = '1';
  List customer_name = [];
  List raod_name = [];
  String? ds;
  String? build_size;
  String? build_price;
  String? price_per;
  String? Raod_id;
  String? land;
  String? total;
  String? _customer_name;
  String? _property;
  String? _zoning;
  String? formattedDate;
  void today_formart() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
  }

  String? frist_switch;
  @override
  Widget build(BuildContext context) {
    double _h = MediaQuery.of(context).size.height * 0.07;
    double _w = MediaQuery.of(context).size.width * 0.2;
    var pading_r_l_t = EdgeInsets.only(right: 30, left: 30, top: 10);
    var pading_r_l_t_b =
        EdgeInsets.only(right: 30, left: 30, top: 10, bottom: 10);
    var _Sizebox_w = SizedBox(
      width: 10,
    );
    var _Sizebox_h = SizedBox(
      height: 10,
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[900],
          centerTitle: true,
          title: Text('New Executive'),
          // title: Text('$id_only'),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  for (int i = 0;
                      i < requestModelbuildng.conparable_map.length;
                      i++) {
                    if (switchValues[i] == false) {
                      requestModelbuildng.conparable_map.removeAt(i);
                    } else {
                      requestModelbuildng.conparable_map;
                    }
                  }
                  print(requestModelbuildng.conparable_map.length.toString());
                });

                if (start != '' &&
                    end != '' &&
                    _images.length >= 2 &&
                    requestModelbuildng.appriaser.toString() != '[]' &&
                    requestModelbuildng.building.toString() != '[]' &&
                    requestModelbuildng.executive_lon.toString() != '' &&
                    requestModelbuildng.executive_lon != '' &&
                    requestModelbuildng.executive_property_type_id != 0 &&
                    requestModelbuildng.executive_valuation_issue_date != '' &&
                    requestModelbuildng.executive_valuation_date != '' &&
                    requestModelbuildng.executive_customer_id != 0) {
                  APIservice apIservice = APIservice();
                  apIservice.saveExecutive(requestModelbuildng).then(
                    (value) async {
                      if (value.message == "Save Successfully") {
                        add_id();
                        await _uploadImage_Multiple();

                        AwesomeDialog(
                            context: context,
                            animType: AnimType.leftSlide,
                            headerAnimationLoop: false,
                            dialogType: DialogType.success,
                            showCloseIcon: false,
                            title: value.message,
                            autoHide: Duration(seconds: 3),
                            onDismissCallback: (type) {
                              Navigator.pop(context);
                            }).show();
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          headerAnimationLoop: false,
                          title: 'Error',
                          desc: value.message,
                          btnOkOnPress: () {},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red,
                        ).show();
                        print(value.message);
                      }
                    },
                  );
                } else {
                  showConfirmationBottomSheet();
                }
              },
              child: Container(
                height: _h,
                width: _w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.lightGreen[700],
                  boxShadow: [BoxShadow(color: Colors.green, blurRadius: 5)],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Save'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.save_alt_outlined),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 5,
            )
          ],
        ),
        body: SingleChildScrollView(
            //headerSliverBuilder: (context, innerBoxIsScrolled) {
            //return [
            child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _dropdown('', customer_name, 'Customer *', 'customer_id',
                          'customerengname', _customer_name),
                    ],
                  ),
                ),
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _date(Valuation, 'Valuation Date*', 'Valuation Date*'),
                      _Sizebox_w,
                      _date(Issue, 'Issue Date*', ''),
                    ],
                  ),
                ),
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _TextFiled_Input('no_number', 'Purpose', 'null'),
                    ],
                  ),
                ),
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _dropdown('', _list_type, 'Property Type *',
                          'property_type_id', 'property_type_name', _property),
                      _Sizebox_w,
                      _dropdown('Zoning', _list_zoning, 'Zoning', 'zoning_id',
                          'zoning_name', _zoning),
                    ],
                  ),
                ),
                _Text('Land Size', pading_r_l_t_b),
                Land_building(
                  l_get: 'new_executive_no',
                  l: (value) {
                    setState(() {
                      requestModelbuildng.executive_land_lengh = value;
                    });
                  },
                  total: (value) {
                    setState(() {
                      requestModelbuildng.executive_land_total = value;
                    });
                  },
                  w: (value) {
                    setState(() {
                      requestModelbuildng.executive_land_width = value;
                    });
                  },
                ),
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _TextFiled_Input('number', 'Land Price', 'null'),
                      _Sizebox_w,
                      _TextFiled_Input('number', 'Total', 'null'),
                    ],
                  ),
                ),

                _Text('Market Price (Per sqr)', pading_r_l_t_b),
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _TextFiled_Input('number', 'Min Price', 'null'),
                      _Sizebox_w,
                      _TextFiled_Input('number', 'Max Price', 'null'),
                    ],
                  ),
                ),
                build_add(),
                (requestModelbuildng.building.length != 0)
                    ? list_view(requestModelbuildng.building, '1')
                    : SizedBox(),
                Appraiser_add(),
                (requestModelbuildng.appriaser.length != 0)
                    ? list_view(requestModelbuildng.appriaser, '2')
                    : SizedBox(),
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _TextFiled_Input('no_number', 'Property Name', ''),
                      _Sizebox_w,
                      _TextFiled_Input('no_number', 'Obligation Concern', ''),
                    ],
                  ),
                ),
                //////sssssssssssss
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _TextFiled_Input('number', 'Gross Floor Area (GFA)', ''),
                      _Sizebox_w,
                      _TextFiled_Input('number', 'Fair Market Value', ''),
                    ],
                  ),
                ),
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _TextFiled_Input('no_number', 'Forced Sale Value', ''),
                      _Sizebox_w,
                      _TextFiled_Input('no_number', 'Fire Insurance Value', ''),
                    ],
                  ),
                ),
                skc(
                    'address : ${(address == 'null') ? '' : address}',
                    'Province : ${(province_name == 'null') ? '' : province_name}',
                    'District : ${(district_name == 'null') ? '' : district_name}',
                    'Cummune : ${(cummune_name == 'null') ? '' : cummune_name}'),
                dropdown_(raod_name),
                Remark(),
                (_images.length != 0) ? mutiple_pic() : SizedBox(),
                Mutiple_image_button(),
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _TextFiled_Input('no_number', 'Latitude *', ''),
                      _Sizebox_w,
                      _TextFiled_Input('no_number', 'Longitude *', ''),
                    ],
                  ),
                ),
                Padding(
                  padding: pading_r_l_t,
                  child: Row(
                    children: [
                      _date_day('From Date*', '', fromdate),
                      _Sizebox_w,
                      _date_day('To Date*', '', todate)
                    ],
                  ),
                ),
                google_map(),
                // data_table(context),
                // _switch(),
                // Text(list_comeback.toString())
                //Text(list_comeback_bool.toString())
              ],
            ),
          ],
        )
            //];
            //}
            //body: ScrollerViewContainer_(),
            // body: ScrollerViewContainer(
            //   List_map_back_bool: (value) {
            //     setState(() {
            //       list_comeback_bool = value;
            //     });
            //   },
            //   List_map_back: (value) {
            //     setState(() {
            //       list_comeback = value;
            //     });
            //   },
            //   conparable_map: requestModelbuildng.conparable_map,
            //   list_map: list_comparble,
            // ),
            ));
  }

  Widget ScrollerViewContainer_() {
    return (list_comparble.length != 0)
        ? SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Row(
                        children: [
                          container('No', 'color'),
                          container('Action', 'color'),
                          container('Property Type', 'color'),
                          container('Land Size', 'color'),
                          container('Building Size', 'color'),
                          container('Asking', 'color'),
                          container('Offered', 'color'),
                          container('Bought', 'color'),
                          container('Sold Out', 'color'),
                          container('Location', 'color'),
                          container('Survey Date', 'color'),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 2)),
                        width: 30 *
                            50.0, // Set the width of the container to accommodate all the List items
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: list_comparble.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  width: double.infinity,
                                  color: Color.fromARGB(255, 41, 27, 133),
                                  child: Row(
                                    children: [
                                      // Text(switchValues[index].toString()),
                                      container(index, 'no_color'),
                                      _switch(index,
                                          requestModelbuildng.conparable_map),
                                      container(
                                          list_comparble[index]
                                                  ['property_type_name']
                                              .toString(),
                                          'no_color'),
                                      container(
                                          list_comparble[index]
                                                  ['comparable_land_total']
                                              .toString(),
                                          'no_color'),
                                      container(
                                          list_comparble[index]
                                                  ['comparable_sold_total']
                                              .toString(),
                                          'no_color'),
                                      container(
                                          list_comparble[index]
                                                  ['comparable_adding_price']
                                              .toString(),
                                          'no_color'),
                                      container(
                                          (list_comparble[index]
                                                          ['comparableaddprice']
                                                      .toString() ==
                                                  'null'
                                              ? ''
                                              : list_comparble[index]
                                                      ['comparableaddprice']
                                                  .toString()),
                                          'no_color'),
                                      container(
                                          (list_comparble[index][
                                                          'comparableboughtprice']
                                                      .toString() ==
                                                  'null'
                                              ? ''
                                              : list_comparble[index]
                                                      ['comparableboughtprice']
                                                  .toString()),
                                          'no_color'),
                                      container(
                                          list_comparble[index]
                                                  ['comparable_sold_price']
                                              .toString(),
                                          'no_color'),
                                      container(
                                          '${(list_comparble[index]['provinces_name'].toString() == 'null' ? '' : list_comparble[index]['provinces_name'].toString())} ${(list_comparble[index]['district_name'].toString() == 'null' ? '' : list_comparble[index]['district_name'].toString())} ${(list_comparble[index]['commune_name'].toString() == 'null' ? '' : list_comparble[index]['commune_name'].toString())}',
                                          'no_color'),
                                      container(
                                          '${list_comparble[index]['comparable_survey_date'].toString()}',
                                          'no_color'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox();
  }

  Widget container(text, color) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.height * 0.12,
        decoration: (color == 'no_color')
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 31, 6, 158),
              ),
        child: Text(
          '$text',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.016,
              color: Colors.white),
        ),
      ),
    );
  }

  List list_comeback_bool = [];
  List list_comeback = [];
  TextEditingController? _log;
  TextEditingController? _lat;
  String? Purpose = '';

  String? executive_lon = '';
  String? executive_lng = '';

  List _list_type = [];
  void _hometype() async {
    setState(() {});
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/properties_dropdown'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      // print(jsonData);
      // print(jsonData);

      setState(() {
        _list_type = jsonData;
      });
    }
  }

  List _list_zoning = [];
  void zoning() async {
    setState(() {});
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/zoning/name'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      // print(jsonData);
      // print(jsonData);

      setState(() {
        _list_zoning = jsonData;
      });
    }
  }

  List _list_comparable = [];
  void get_comparable() async {
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/search_comparable/11.123123132/104.123123?start=2019-2-1&end=2023-1-1'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      setState(() {
        _list_comparable = jsonData;
      });
    }
  }

  String? id_only;
  List ID_List = [];
  void last_id() async {
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/ex_last/id'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      setState(() {
        ID_List = jsonData;
        var a = int.parse(ID_List[0]['executive_id'].toString()) + 1;
        id_only = a.toString();
        requestModelbuildng.executive_id = int.parse(id_only.toString());
      });
    }
  }

  List list_comparble = [];
  List<Map<String, dynamic>> list_map = [];
  String? comparablecode = '';
  String? start = '';
  String? end = '';
  Widget google_map() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return Map_Search_Comparable_(
                delect_first_time: (value) {},
                back_f_value: (value) {},
                executive_map_table_comback: [],
                executive_map_table: (value) {},
                list_CP: list_comparble,
                list_comparable: (value) {
                  setState(() {
                    list_comparble = value;
                    print(list_comparble.toString());
                  });
                },
                list: requestModelbuildng.conparable_map,
                listback: (value) {
                  setState(() {
                    requestModelbuildng.conparable_map = value;
                  });
                },
                y_lat: (value) {
                  setState(() {
                    requestModelbuildng.executive_lon = value.toString();
                    _lat = TextEditingController(
                        text: '${requestModelbuildng.executive_lon}');
                    requestModelbuildng.executive_lon = _lat!.text;
                  });
                },
                y_log: (value) {
                  setState(() {
                    requestModelbuildng.executive_lng = value.toString();
                    _log = TextEditingController(
                        text: '${requestModelbuildng.executive_lng}');
                    requestModelbuildng.executive_lng = _log!.text;
                  });
                },
                comparablecode: (value) {
                  setState(() {
                    comparablecode = value;
                  });
                },
                id: id_only,
                start: start,
                end: end,
                hh_: '30',
                get_commune: (value) {},
                get_district: (value) {},
                get_lat: (value) {
                  setState(() {
                    // lat = value;
                  });
                },
                get_log: (value) {
                  setState(() {
                    // log = value;
                  });
                },
                get_max1: (value) {},
                get_max2: (value) {},
                get_min1: (value) {},
                get_min2: (value) {},
                get_province: (value) {},
              );
            },
          ));
        },
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                // color: Color.fromARGB(255, 59, 22, 169),
                borderRadius: BorderRadius.circular(10)),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 1,
            child: Image.network(
              'https://www.agiratech.com/wp-content/uploads/2020/04/google_maps.png',
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Widget _date_day(lable, value, controller) {
    return Expanded(
      child: TextField(
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.015,
        ),
        controller: controller, //editing controller of this TextField
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.calendar_today,
            color: kImageColor,
            size: MediaQuery.of(context).size.height * 0.025,
          ), //icon of text field
          labelText: "${lable}",
          fillColor: kwhite,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kPrimaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: kPrimaryColor,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ), //label text of field
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101));

          if (pickedDate != null) {
            (lable == 'From Date*')
                ? start = DateFormat('yyyy-MM-dd').format(pickedDate)
                : end = DateFormat('yyyy-MM-dd').format(pickedDate);

            setState(() {
              (lable == 'From Date*')
                  ? controller.text = start!
                  : controller.text = end;
            });
          } else {
            print("Date is not selected");
          }
        },
      ),
    );
  }

  List<building_execuactive> lb = [
    building_execuactive(0, '', '', '', '', 1, '')
  ];
  void deleteItemToList(int Id) {
    setState(() {
      // print(requestModelbuildng.building.length.toString());
      // requestModelbuildng.building != list;
      // requestModelbuildng.building.removeAt(Id);
      lb.removeAt(int.parse(Id.toString()));
    });
  }

  void showConfirmationBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You need Input',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.02),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (requestModelbuildng.executive_customer_id == 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Customer *',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017),
                                  ),
                                )
                              : SizedBox(),
                          (requestModelbuildng.executive_valuation_date == '')
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Valuation Date *',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017),
                                  ),
                                )
                              : SizedBox(),
                          (start == '')
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'From Date *',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017),
                                  ),
                                )
                              : SizedBox(),
                          (end == '')
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'To Date *',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      Column(
                        children: [
                          (requestModelbuildng.executive_valuation_issue_date ==
                                  '')
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Issue Date*',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017),
                                  ),
                                )
                              : SizedBox(),
                          (requestModelbuildng.executive_property_type_id == 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Property Type*',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017),
                                  ),
                                )
                              : SizedBox(),
                          (requestModelbuildng.executive_lon == '')
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Google Map(Latiture * /Longitude *)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017),
                                  ),
                                )
                              : SizedBox(),
                          (requestModelbuildng.building.toString() == '[]')
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Building *',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017),
                                  ),
                                )
                              : SizedBox(),
                          (requestModelbuildng.appriaser.toString() == '[]')
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Appraiser *',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017),
                                  ),
                                )
                              : SizedBox(),
                          (_images.length >= 2)
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Mutiple Image *',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<File> _images = [];
  Widget mutiple_pic() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 2)),
        height: MediaQuery.of(context).size.height * 0.43,
        width: double.infinity,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(_images.length, (index) {
            return Image.file(
              _images[index],
              fit: BoxFit.cover,
            );
          }),
        ),
      ),
    );
  }

  Widget Mutiple_image_button() {
    var pading_r_l_t = EdgeInsets.only(right: 30, left: 30, top: 10);
    return Padding(
      padding: pading_r_l_t,
      child: InkWell(
        onTap: pickImages,
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.07,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color.fromARGB(255, 47, 22, 157)),
          child: Text(
            'Mutiple Image *',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> pickImages() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
      );
    } on Exception {
      // Handle exception
    }
    // setState(() {
    //   _images;
    // });

    List<File> files = [];
    for (var asset in resultList) {
      ByteData byteData = await asset.getByteData();
      final tempDir = await getTemporaryDirectory();

      final file = File('${tempDir.path}/${asset.name}');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      files.add(file);
    }

    setState(() {
      _images = files;
    });
  }

  Widget Remark() {
    var pading_r_l_t = EdgeInsets.only(right: 30, left: 30, top: 10);
    return Padding(
      padding: pading_r_l_t,
      child: Expanded(
        child: TextFormField(
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.015,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (value) {
            setState(() {
              requestModelbuildng.executive_remarks = value;
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            prefixIcon: Icon(
              Icons.feed_outlined,
              color: kImageColor,
            ),
            hintText: 'Remark',
            fillColor: kwhite,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: kPrimaryColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: kPrimaryColor,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropdown_(list) {
    var pading_r_l_t = EdgeInsets.only(right: 30, left: 30, top: 10);
    return Padding(
      padding: pading_r_l_t,
      child: Container(
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          //value: genderValue,
          onChanged: (newValue) {
            setState(() {
              requestModelbuildng.executive_road_type_id =
                  int.parse(newValue.toString());
            });
          },
          value: Raod_id,
          items: list
              .map<DropdownMenuItem<String>>(
                (value) => DropdownMenuItem<String>(
                  value: value["road_id"].toString(),
                  child: Text(
                    value["road_name"].toString(),
                    style: TextStyle(
                        fontSize: MediaQuery.textScaleFactorOf(context) * 13,
                        height: 0.1),
                  ),
                ),
              )
              .toList(),
          // add extra sugar..
          icon: Icon(
            Icons.arrow_drop_down,
            color: kImageColor,
          ),

          decoration: InputDecoration(
            fillColor: kwhite,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            labelText: 'Raod',
            hintText: 'Raod',
            prefixIcon: Icon(
              Icons.app_registration_sharp,
              color: kImageColor,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kPrimaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: kPrimaryColor,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget Appraiser_add() {
    var pading_r_l_t = EdgeInsets.only(right: 30, left: 30, top: 10);
    return Padding(
      padding: pading_r_l_t,
      child: InkWell(
        onTap: () {
          _asyncInputDialog(context, '');
          ++i;
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 40,
          decoration: BoxDecoration(
              border: Border(),
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: Color.fromARGB(160, 0, 0, 0),
                    offset: Offset(0, 1.5))
              ],
              color: Color.fromARGB(255, 9, 126, 7),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("land~Building"),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Horizon',
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('Appraiser *'),
                    ],
                    pause: const Duration(milliseconds: 100),
                    repeatForever: true,
                  ),
                ),
              ),
              GFAnimation(
                controller: controller,
                slidePosition: offsetAnimation,
                type: GFAnimationType.slideTransition,
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 30,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                ),
              ),
            ],
          ),
        ),
        // icon: Icon(
        //   Icons.add_circle_outline,
        //   color: Colors.white,
        // ),
      ),
    );
  }

  Widget build_add() {
    var pading_r_l_t = EdgeInsets.only(right: 30, left: 30, top: 10);
    return Padding(
      padding: pading_r_l_t,
      child: InkWell(
        onTap: () {
          _asyncInputDialog(context, 'building');
          ++i;
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 40,
          decoration: BoxDecoration(
              border: Border(),
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: Color.fromARGB(160, 0, 0, 0),
                    offset: Offset(0, 1.5))
              ],
              color: Color.fromARGB(255, 9, 126, 7),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("land~Building"),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Horizon',
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('Building*'),
                    ],
                    pause: const Duration(milliseconds: 100),
                    repeatForever: true,
                  ),
                ),
              ),
              GFAnimation(
                controller: controller,
                slidePosition: offsetAnimation,
                type: GFAnimationType.slideTransition,
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 30,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                ),
              ),
            ],
          ),
        ),
        // icon: Icon(
        //   Icons.add_circle_outline,
        //   color: Colors.white,
        // ),
      ),
    );
  }

  void add_id() async {
    try {
      Map<String, dynamic> payload = {
        'executive_id': int.parse(id_only.toString()),
      };

      final url = Uri.parse(
          'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/ex_last_id');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
      } else {}
    } catch (error) {}
  }

  Widget list_view(List list, lable) {
    var _Sizebox_h = SizedBox(
      height: 10,
    );
    var pading_r_l_t = EdgeInsets.only(right: 30, left: 30, top: 10);
    var _font = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.height * 0.02);
    return Padding(
      padding: pading_r_l_t,
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 0.7)),
        height: MediaQuery.of(context).size.height * 0.35,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.31,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      // color: Color.fromARGB(255, 255, 254, 252),
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  (lable == '1')
                                      ? requestModelbuildng.building
                                          .removeAt(index)
                                      : requestModelbuildng.appriaser
                                          .removeAt(index);
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 166, 37, 28),
                              )),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (lable == '1')
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Discription'),
                                        _Sizebox_h,
                                        Text('Building Size'),
                                        _Sizebox_h,
                                        Text('Building Price'),
                                        _Sizebox_h,
                                        Text('Price Per Sqm'),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ': ${(list[index]['building_des'].toString() != 'null') ? list[index]['building_des'].toString() : ''}',
                                          style: _font,
                                        ),
                                        _Sizebox_h,
                                        Text(
                                          ': ${(list[index]['building_size'].toString() != 'null') ? list[index]['building_size'].toString() : ''} sqm',
                                          style: _font,
                                        ),
                                        _Sizebox_h,
                                        Text(
                                          ': ${(list[index]['building_price'].toString() != 'null') ? list[index]['building_price'].toString() : ''} \$',
                                          style: _font,
                                        ),
                                        _Sizebox_h,
                                        Text(
                                          ': ${(list[index]['building_price_per'].toString() != 'null') ? list[index]['building_price_per'].toString() : ''} \$/sqm',
                                          style: _font,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Price'),
                                        _Sizebox_h,
                                        Text('Agent Name'),
                                        _Sizebox_h,
                                        Text('Remark'),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ': ${(list[index]['appraiser_price'].toString() != 'null') ? list[index]['appraiser_price'].toString() : ''} \$',
                                          style: _font,
                                        ),
                                        _Sizebox_h,
                                        Text(
                                          ': ${(list[index]['agenttype_name'].toString() != 'null') ? list[index]['agenttype_name'].toString() : ''}',
                                          style: _font,
                                        ),
                                        _Sizebox_h,
                                        Text(
                                          ': ${(list[index]['appraiser_remark'].toString() != 'null') ? list[index]['appraiser_remark'].toString() : ''}',
                                          style: _font,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }

  List onchage_list = [];
  List onchage_list_ = [];
  int i = 0;
  Future _asyncInputDialog(BuildContext context, name) async {
    return showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          insetPadding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 10),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.height * 0.8,
            child: ((name == 'building'))
                ? LandBuilding_valuaction_new(
                    id: id_only,
                    list: requestModelbuildng.building,
                    listback: (value) {
                      setState(() {
                        // onchage_list = value;
                        requestModelbuildng.building = value;
                      });
                    },
                  )
                : LandBuilding_Appraiser_new(
                    id: id_only,
                    list: requestModelbuildng.appriaser,
                    listback: (value) {
                      setState(() {
                        requestModelbuildng.appriaser = value;
                      });
                    },
                  ),
            // child: (name == 'building')
            //     ? Building(context)
            //     : Appraisering(context),
          ),
        );
      },
    );
  }

  void _road() async {
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/raod/name'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      setState(() {
        raod_name = jsonData;
        print(raod_name.toString());
      });
    }
  }

  void _Customer_name() async {
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/Name_customer'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      setState(() {
        customer_name = jsonData;
      });
    }
  }

  Widget _Text(text, pad) {
    return Padding(
      padding: pad,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height * 0.025),
      ),
    );
  }

  Widget skc(text1, text2, text3, text4) {
    var _Sizebox_h = SizedBox(
      height: 10,
    );
    var pading_r_l_t = EdgeInsets.only(right: 30, left: 30, top: 10);
    return Padding(
      padding: pading_r_l_t,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 238, 233, 233),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text1),
            ),
          ),
          _Sizebox_h,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 238, 233, 233),
            ),
            height: MediaQuery.of(context).size.height * 0.06,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text2),
            ),
          ),
          _Sizebox_h,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 238, 233, 233),
            ),
            height: MediaQuery.of(context).size.height * 0.06,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text3),
            ),
          ),
          _Sizebox_h,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 238, 233, 233),
            ),
            height: MediaQuery.of(context).size.height * 0.06,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text4),
            ),
          ),
        ],
      ),
    );
  }

  Widget Appraisering(BuildContext) {
    var Size_h = EdgeInsets.only(right: 30, left: 30, top: 10);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Size_h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Appraiser *',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.remove_circle_outline_sharp,
                          color: Colors.red,
                          size: MediaQuery.of(context).size.height * 0.05,
                        )),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: Size_h,
            child: Row(
              children: [
                _TextFiled_Input('number', 'Price', ds),
              ],
            ),
          ),
          Padding(
            padding: Size_h,
            child: Row(
              children: [
                _TextFiled_Input('no_number', 'Agent Name', build_size),
              ],
            ),
          ),
          Padding(
            padding: Size_h,
            child: Row(
              children: [
                _TextFiled_Input('no_number', '	Remark', build_price),
              ],
            ),
          ),
          Padding(
              padding: Size_h,
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.08,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 52, 167, 56),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: GFButton(
                    elevation: 10,
                    onPressed: () {},
                    text: "Save",
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.024),
                    color: Color.fromARGB(255, 21, 142, 8),
                    icon: Icon(Icons.save),
                    type: GFButtonType.outline2x,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _date(contrller, labletext, date) {
    return Expanded(
      child: TextField(
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.015,
        ),
        controller: contrller, //editing controller of this TextField
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.calendar_today,
            color: kImageColor,
            size: MediaQuery.of(context).size.height * 0.025,
          ), //icon of text field
          labelText: "${labletext}",
          labelStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.013,
              fontWeight: FontWeight.bold),
          fillColor: kwhite,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kPrimaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: kPrimaryColor,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ), //label text of field
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101));

          if (pickedDate != null) {
            (date == 'Valuation Date*')
                ? requestModelbuildng.executive_valuation_date =
                    DateFormat('yyyy-MM-dd').format(pickedDate)
                : requestModelbuildng.executive_valuation_issue_date =
                    DateFormat('yyyy-MM-dd').format(pickedDate);

            setState(() {
              (date == 'Valuation Date*')
                  ? contrller.text =
                      requestModelbuildng.executive_valuation_date
                  : contrller.text =
                      requestModelbuildng.executive_valuation_issue_date;
            });
          } else {
            print("Date is not selected");
          }
        },
      ),
    );
  }

  String? _purpose = '';

  Widget _TextFiled_Input(type, lable, _value) {
    return Expanded(
      child: TextFormField(
        controller: (lable == 'Latitude *')
            ? _lat
            : (lable == 'Longitude *')
                ? _log
                : null,
        readOnly: (lable == 'Latitude *')
            ? true
            : (lable == 'Longitude *')
                ? true
                : false,
        keyboardType: (type == 'number') ? TextInputType.number : null,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.015,
          fontWeight: FontWeight.bold,
        ),
        onChanged: (value) {
          setState(() {
            if (lable == 'Purpose') {
              requestModelbuildng.executive_purpose = value;
            } else if (lable == 'Land Price') {
              requestModelbuildng.executive_land_price = value;
            } else if (lable == 'Total') {
              requestModelbuildng.executive_land_price_per = value;
            } else if (lable == 'Min Price') {
              requestModelbuildng.executive_market_min = value;
            } else if (lable == 'Max Price') {
              requestModelbuildng.executive_market_max = value;
            } else if (lable == 'Property Name') {
              requestModelbuildng.executive_property_name = value;
            } else if (lable == 'Obligation Concern') {
              requestModelbuildng.executive_obligation = value;
            } else if (lable == 'Gross Floor Area (GFA)') {
              requestModelbuildng.executive_building = value;
            } else if (lable == 'Fair Market Value') {
              requestModelbuildng.executive_fire = value;
            } else if (lable == 'Forced Sale Value') {
              requestModelbuildng.executive_fair = value;
            } else if (lable == 'Fire Insurance Value') {
              requestModelbuildng.executive_forced = value;
            } else if (lable == 'Latitude *') {
              requestModelbuildng.executive_lon = value;
              requestModelbuildng.executive_lon = _lat!.text;
            } else if (lable == 'Longitude *') {
              requestModelbuildng.executive_lng = value;
              requestModelbuildng.executive_lng = _log!.text;
            }
          });
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          prefixIcon: Icon(
            Icons.feed_outlined,
            color: kImageColor,
          ),
          hintText: lable,
          fillColor: kwhite,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kPrimaryColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: kPrimaryColor,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  String? customer_id;
  String? property_id;
  String? province_name = '';
  String? province_id;
  String? district_name = '';
  String? district_id;
  String? cummune_name = '';
  String? cummune_id;
  String? address = '';
  Future<void> _uploadImage_Multiple() async {
    final url = Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/executive/image');

    final request = http.MultipartRequest('POST', url);
    request.fields['executive_file_id'] = id_only.toString();

    if (_images != null) {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;

      List<File> compressedImages = [];

      for (int i = 0; i < _images.length; i++) {
        var compressedImageFile = await FlutterImageCompress.compressAndGetFile(
          _images[i].absolute.path,
          '$path/${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
          quality: 70,
        );

        if (compressedImageFile != null) {
          compressedImages.add(compressedImageFile);
        }
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'image1',
          compressedImages[0].path,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'image2',
          compressedImages[1].path,
        ),
      );
      if (_images.length < 3) {
        print('null');
      } else {
        print('no null');
        request.files.add(
          await http.MultipartFile.fromPath(
            'image3',
            compressedImages[2].path,
          ),
        );
      }

      if (_images.length < 4) {
        print('null');
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image4',
            compressedImages[3].path,
          ),
        );
      }
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Images uploaded successfully!');
    } else {
      print('Error uploading images: ${response.reasonPhrase}');
    }
  }

  String? Zoning;
  Widget _dropdown(_value, _list, lable, text_id, text_name, value_get) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        //value: genderValue,
        onChanged: (newValue) {
          setState(() {
            if (lable == 'Property Type *') {
              // property_id = newValue;
              requestModelbuildng.executive_property_type_id =
                  int.parse(newValue.toString());
            } else if (lable == 'Zoning') {
              requestModelbuildng.executive_zone_id =
                  int.parse(newValue.toString());
            } else if (lable == 'Customer *') {
              requestModelbuildng.executive_customer_id =
                  int.parse(newValue.toString());
              for (int i = 0; i < customer_name.length; i++) {
                if (newValue == customer_name[i]['customer_id'].toString()) {
                  province_name = customer_name[i]['provinces_name'].toString();
                  district_name = customer_name[i]['district_name'].toString();
                  cummune_name = customer_name[i]['commune_name'].toString();
                  requestModelbuildng.executive_address =
                      customer_name[i]['customerpropertyaddress'].toString();
                  requestModelbuildng.executive_province_id = int.parse(
                      customer_name[i]['customerpropertyprovince'].toString());
                  requestModelbuildng.executive_district_id = int.parse(
                      customer_name[i]['customerpropertydistrict'].toString());
                  requestModelbuildng.executive_commune_id = int.parse(
                      customer_name[i]['customerpropertycommune'].toString());
                } else {}
              }
            }
          });
        },
        value: value_get,
        items: _list
            .map<DropdownMenuItem<String>>(
              (value) => DropdownMenuItem<String>(
                value: value["$text_id"].toString(),
                child: Form(
                    child: Text(
                  // value["customer_name"].toString(),
                  value['$text_name'].toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.textScaleFactorOf(context) * 8,
                      height: 0.1),
                )),
              ),
            )
            .toList(),
        // add extra sugar..
        icon: Icon(
          Icons.arrow_drop_down,
          color: kImageColor,
        ),

        decoration: InputDecoration(
          labelStyle: (lable == 'Property Type *')
              ? TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.012,
                  fontWeight: FontWeight.bold)
              : null,
          fillColor: kwhite,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          labelText: lable,
          hintText: lable,
          helperStyle: (lable == 'Property Type *')
              ? TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.012,
                  fontWeight: FontWeight.bold)
              : null,
          prefixIcon: Icon(
            Icons.app_registration_sharp,
            color: kImageColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kPrimaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: kPrimaryColor,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  var isSelected;
  Widget data_table(context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
      padding: EdgeInsets.all(5),
      child: PaginatedDataTable(
        horizontalMargin: 5.0,
        arrowHeadColor: Colors.blueAccent[300],
        columns: [
          DataColumn(
              label: Text(
            'No',
            style: TextStyle(color: Colors.green),
          )),
          DataColumn(
              label: Text(
            'ID',
            style: TextStyle(color: Colors.green),
          )),
          DataColumn(
              label: Text(
            'Action',
            style: TextStyle(color: Colors.green),
          )),
        ],
        dataRowHeight: 50,
        rowsPerPage: on_row,
        onRowsPerPageChanged: (value) {
          setState(() {
            on_row = value!;
          });
        },
        source: new _DataSource(requestModelbuildng.conparable_map,
            requestModelbuildng.conparable_map.length, context, list_comparble),
      ),
    );
  }

  int index_map = 0;
  List<bool> switchValues = [];
  String? f = 'one';
  String? delete = 'delect';
  Widget _switch(index, list) {
    f == 'one'
        ? switchValues = List<bool>.generate(
            requestModelbuildng.conparable_map.length, (index) => true)
        : null;
    return Switch(
      value: switchValues[index],
      onChanged: (value) {
        setState(() {
          f = 'two';

          switchValues[index] = value;
          print(index.toString());

          // if (f == 'two') {
          //   // widget.list_map.removeAt(index);
          // } else {}
        });
      },
    );
  }

  int on_row = 10;
  //For List
  String? building_executive_id;
  String? building_size;
  String? building_price;
  String? building_price_per;
  String? building_des;
  List list = [];
  void addItemToList() {
    setState(() {
      list.add({
        "building_executive_id": id_only,
        "building_size": '',
        "building_price": '',
        "building_price_per": '',
        "building_des": '',
      });
      lb.add(
        building_execuactive(int.parse(id_only.toString()), building_size,
            building_price, building_price_per, '', 1, ''),
      );
    });
    //  print(id);
  }
}

// https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/search_comparable/$lat_verbal/$log_verbal?start=${widget.start}&end=${widget.end}
class _DataSource extends DataTableSource {
  final List data;
  final List data1;
  final int count_row;
  final BuildContext context;

  _DataSource(this.data, this.count_row, this.context, this.data1);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    final list_com = data1[index];
    final item = data[index];
    bool isSelected = false;
    return DataRow(
        selected: true,
        color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return index % 2 == 0
                  ? Color.fromARGB(168, 73, 83, 224)
                  : Colors.white;
            }
            return index % 2 == 0
                ? Color.fromARGB(255, 255, 162, 162)
                : Colors.white;
          },
        ),
        cells: [
          DataCell(
            placeholder: true,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '$index',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {},
          ),
          DataCell(
            placeholder: true,
            Column(
              children: [
                Switch(
                  value: true,
                  onChanged: (value) {
                    ;
                  },
                ),
              ],
            ),
            onTap: () {},
          ),
          // DataCell(
          //   placeholder: true,
          //   Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       Text(
          //         '${item['propertycomparable_com_id'].toString()}',
          //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          //   onTap: () {},
          // ),
          DataCell(
            placeholder: true,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${list_com['property_type_name'].toString()}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {},
          ),
          DataCell(
            placeholder: true,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${list_com['comparable_land_total'].toString()}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {},
          ),
          DataCell(
            placeholder: true,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${list_com['comparable_sold_total'].toString()}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {},
          ),
          DataCell(
            placeholder: true,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${list_com['comparable_adding_price'].toString()}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {},
          ),
          DataCell(
            placeholder: true,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${(list_com['comparableaddprice'].toString() == 'null' ? '' : list_com['comparableaddprice'].toString())}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {},
          ),
          DataCell(
            placeholder: true,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${(list_com['comparableboughtprice'].toString() == 'null' ? '' : list_com['comparableboughtprice'].toString())}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {},
          ),
          DataCell(
            placeholder: true,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${list_com['comparable_sold_price'].toString()}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {},
          ),
          DataCell(
            placeholder: true,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${(list_com['provinces_name'].toString() == 'null' ? '' : list_com['provinces_name'].toString())} ${(list_com['district_name'].toString() == 'null' ? '' : list_com['district_name'].toString())} ${(list_com['commune_name'].toString() == 'null' ? '' : list_com['commune_name'].toString())}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {},
          ),
          DataCell(
            placeholder: true,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${list_com['comparable_survey_date'].toString()}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {},
          ),
        ]);
  }

  @override
  int get rowCount => count_row;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
