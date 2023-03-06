// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/services.dart';
import 'package:getwidget/components/animation/gf_animation.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:getwidget/types/gf_animation_type.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Customs/formTwinN.dart';
import '../../../../components/ApprovebyAndVerifyby.dart';
import '../../../../components/LandBuilding.dart';
import '../../../../components/bank.dart';
import '../../../../components/code.dart';
import '../../../../components/comment.dart';
import '../../../../components/forceSale.dart';
import '../../../../components/property.dart';
import '../../../../components/slideUp.dart';
import '../../../../contants.dart';
import '../../../../customs/form.dart';
import '../../../../model/land_building.dart';
import '../../../../model/models/autoVerbal.dart';
import '../../../../respon.dart';
import '../../../../server/api_service.dart';

class New_Veba extends StatefulWidget {
  const New_Veba({super.key, required this.id});
  final String id;
  @override
  State<New_Veba> createState() => _AddState();
}

class _AddState extends State<New_Veba> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String fromValue = 'Bank';
  String genderValue = 'Female';
  int opt = 0;
  double asking_price = 1;
  String address = '';
  String propertyType = '', propertyTypeValue = '';
  var code = 0;
  TextEditingController dateinput = TextEditingController();
  late AutoVerbalRequestModel requestModelAuto;
  var from = [
    'Bank',
    'Private',
    'Other',
  ];
  var gender = [
    'Female',
    'Male',
    'Other',
  ];

  var district;

  late List<dynamic> list_Khan;

  int id_khan = 0;

  var a;

  var opt_type_id = '0';
  List list = [];
  List<L_B> lb = [L_B('', '', '', '', 0, 0, 0, 0, 0, 0)];
  void deleteItemToList(int Id) {
    setState(() {
      lb.removeAt(Id);
    });
  }

  late AnimationController controller;
  late Animation<double> animation;
  late Animation<Offset> offsetAnimation;
  @override
  void initState() {
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
    lb;
    requestModelAuto = AutoVerbalRequestModel(
      property_type_id: "",
      lat: "",
      lng: "",
      address: '',
      approve_id: "",
      agent: "",
      bank_branch_id: "",
      bank_contact: "",
      bank_id: "",
      bank_officer: "",
      code: "",
      comment: "",
      contact: "",
      date: "",
      image: "",
      option: "",
      owner: "",
      user: "10",
      verbal_com: '',
      verbal_con: "",
      verbal: [],
      verbal_id: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                uploadt_image(_file);
              });
              requestModelAuto.user = widget.id;
              requestModelAuto.verbal_id = code;
              if (validateAndSave()) {
                APIservice apIservice = APIservice();
                apIservice.saveVerbal(requestModelAuto).then(
                  (value) async {
                    print('Error');
                    print(json.encode(requestModelAuto.toJson()));
                    if (requestModelAuto.verbal.isEmpty) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        headerAnimationLoop: false,
                        title: 'Error',
                        desc: "Please add Land/Building at least 1!",
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red,
                      ).show();
                    } else {
                      if (value.message == "Save Successfully") {
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
                    }
                  },
                );
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 5),
              decoration: BoxDecoration(
                color: Colors.lightGreen[700],
                boxShadow: [BoxShadow(color: Colors.green, blurRadius: 5)],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                  bottomLeft: Radius.circular(80),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text("Submit"),
                  Icon(Icons.save_alt_outlined),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 10,
                    height: 20,
                    alignment: Alignment.topRight,
                    color: Colors.red[700],
                  )
                ],
              ),
            ),
          ),
        ],
        title: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22.0,
            shadows: [
              Shadow(blurRadius: 2, color: Color.fromRGBO(255, 235, 238, 1))
            ],
            fontWeight: FontWeight.bold,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText('Verbal',
                  textAlign: TextAlign.center,
                  textStyle:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
            ],
            pause: const Duration(milliseconds: 900),
            isRepeatingAnimation: true,
            repeatForever: true,
            onTap: () {},
          ),
        ),
        toolbarHeight: 80,
      ),
      backgroundColor: Colors.purple[800],
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Responsive(
              mobile: addVerbal(context),
              tablet: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: addVerbal(context),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              desktop: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: addVerbal(context),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              phone: addVerbal(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget addVerbal(BuildContext context) {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables, duplicate_ignore
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Code(
                  code: (value) {
                    setState(() {
                      code = value;
                    });
                  },
                  check_property: 2,
                ),
                // ignore: sized_box_for_whitespace
                //dropdown(),
                // PropertyDropdown(),
                SizedBox(
                  height: 10.0,
                ),
                PropertyDropdown(
                  name: (value) {
                    propertyType = value;
                  },
                  id: (value) {
                    requestModelAuto.property_type_id = value;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                BankDropdown(
                  bank: (value) {
                    requestModelAuto.bank_id = value;
                  },
                  bankbranch: (value) {
                    requestModelAuto.bank_branch_id = value;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                FormTwinN(
                  Label1: 'Owner',
                  Label2: 'Contact',
                  onSaved1: (input) {
                    requestModelAuto.owner = input!;
                  },
                  onSaved2: (input) {
                    requestModelAuto.contact = input!;
                  },
                  icon1: Icon(
                    Icons.person,
                    color: kImageColor,
                  ),
                  icon2: Icon(
                    Icons.phone,
                    color: kImageColor,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                // DateComponents(
                //   date: (value) {
                //     requestModelAuto.date = value;
                //   },
                // ),
                SizedBox(
                  height: 10.0,
                ),
                FormTwinN(
                  Label1: 'Bank Officer',
                  Label2: 'Contact',
                  onSaved1: (input) {
                    requestModelAuto.bank_officer = input!;
                  },
                  onSaved2: (input) {
                    requestModelAuto.bank_contact = input!;
                  },
                  icon1: Icon(
                    Icons.work,
                    color: kImageColor,
                  ),
                  icon2: Icon(
                    Icons.phone,
                    color: kImageColor,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                ForceSaleAndValuation(
                  value: (value) {
                    requestModelAuto.verbal_con = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CommentAndOption(
                  value: (value) {
                    opt = int.parse(value);
                  },
                  id: (value) {
                    requestModelAuto.option = value;
                  },
                  comment: (String? newValue) {
                    requestModelAuto.comment = newValue!;
                  },
                  opt_type_id: (value) {
                    opt_type_id = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ApprovebyAndVerifyby(
                  approve: (value) {
                    requestModelAuto.approve_id = value;
                  },
                  verify: (value) {
                    requestModelAuto.agent = value;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                FormS(
                  label: 'Address',
                  onSaved: (input) {
                    requestModelAuto.address = input!;
                  },
                  iconname: Icon(
                    Icons.location_on_rounded,
                    color: kImageColor,
                  ),
                ),
                SizedBox(
                  height: 3.0,
                ),
                // if (id_khan == 0)
                TextButton(
                  onPressed: () {
                    SlideUp(context);
                  },
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22, right: 22),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        // padding: EdgeInsets.only(left: 30, right: 30),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.map_sharp,
                                  color: kImageColor,
                                ),
                                SizedBox(width: 10),
                                Text((asking_price == 1)
                                    ? 'Choose Location'
                                    : 'Choosed Location'),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),

                // FileOpen(),
                // SizedBox(
                //   height: 5,
                // ),

                // ImageController(),
                // ImageOpen(
                //   set_Image: (value) {
                //     requestModelAuto.image = value;
                //   },
                // ),
                SingleChildScrollView(
                  child: Column(children: [
                    imagepath != "" ? Image.file(File(imagepath)) : SizedBox(),
                    if (imagepath == "")
                      TextButton(
                        onPressed: () {
                          openImage();
                        },
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 22, right: 22),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: kPrimaryColor,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              // padding: EdgeInsets.only(left: 30, right: 30),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.map_sharp,
                                        color: kImageColor,
                                      ),
                                      SizedBox(width: 10),
                                      // ignore: unnecessary_null_comparison
                                      Text((imagepath == "")
                                          ? 'Choose Photo'
                                          : 'choosed Photo'),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                  ]),
                ),

                if (id_khan != 0)
                  InkWell(
                    onTap: () {
                      _asyncInputDialog(context);
                      ++i;
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border(),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                color: Color.fromARGB(160, 0, 0, 0),
                                offset: Offset(0, 1.5))
                          ],
                          color: Colors.lightBlueAccent[700],
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
                                  RotateAnimatedText('land'),
                                  RotateAnimatedText('Building'),
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
                              shadows: [
                                Shadow(blurRadius: 5, color: Colors.black)
                              ],
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
                if (i >= 0)
                  Container(
                    width: 500,
                    height: 290,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 1; i < lb.length; i++)
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Container(
                                width: 290,
                                //height: 210,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: kPrimaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '${lb[i].verbal_land_type} ',
                                                style: NameProperty(),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteItemToList(i);
                                                      print(list);
                                                    });
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Text.rich(
                                        TextSpan(
                                          children: <InlineSpan>[
                                            WidgetSpan(
                                                child: Icon(
                                              Icons.location_on_sharp,
                                              color: kPrimaryColor,
                                              size: 14,
                                            )),
                                            TextSpan(text: "${lb[i].address} "),
                                          ],
                                        ),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3.0,
                                    ),
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        lb[i].verbal_land_des,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Depreciation",
                                              style: Label(),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "Area",
                                              style: Label(),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              'Min Value/Sqm',
                                              style: Label(),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              'Max Value/Sqm',
                                              style: Label(),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              'Min Value',
                                              style: Label(),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              'Min Value',
                                              style: Label(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 15),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 4),
                                            Text(
                                              ':   ' + lb[i].verbal_land_dp,
                                              style: Name(),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              ':   ' +
                                                  (lb[i]
                                                          .verbal_land_area
                                                          .toInt())
                                                      .toString() +
                                                  'm' +
                                                  '\u00B2',
                                              style: Name(),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              ':   ' +
                                                  (lb[i].verbal_land_minsqm)
                                                      .toString() +
                                                  '\$',
                                              style: Name(),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              ':   ' +
                                                  (lb[i].verbal_land_maxsqm)
                                                      .toString() +
                                                  '\$',
                                              style: Name(),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              ':   ' +
                                                  (lb[i].verbal_land_minvalue)
                                                      .toString() +
                                                  '\$',
                                              style: Name(),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              ':   ' +
                                                  (lb[i]
                                                          .verbal_land_maxvalue
                                                          .toString() +
                                                      '\$'),
                                              style: Name(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  var dropdown;
  String? options;
  String? commune;
  //MAP
  Future<void> SlideUp(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                c_id: code.toString(),
                district: (value) {
                  setState(() {
                    district = value;
                    Load_khan(district);
                  });
                },
                commune: (value) {
                  setState(() {
                    commune = value;
                    Load_sangkat(value);
                  });
                },
                lat: (value) {
                  setState(() {
                    requestModelAuto.lat = value;
                  });
                },
                log: (value) {
                  setState(() {
                    requestModelAuto.lng = value;
                  });
                },
                province: (value) {},
              )),
    );
    setState(() {
      requestModelAuto.image = code.toString();
    });
    if (!mounted) return;
    // asking_price = result[0]['adding_price'];
    // address = result[0]['address'];
    // requestModelAuto.lat = result[0]['lat'];
    // requestModelAuto.lng = result[0]['lng'];
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

//===================== Upload Image to MySql Server
  late File _image;
  final picker = ImagePicker();
  late String base64string;
  late File _file;
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  openImage() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        imagepath = pickedFile.path;
        print(imagepath);
        //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg
        File imagefile = File(imagepath); //convert Path to File
        // saveAutoVerbal(imagefile);
        Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
        String base64string =
            base64.encode(imagebytes); //convert bytes to base64 string
        Uint8List decodedbytes = base64.decode(base64string);
        //decode base64 stirng to bytes
        setState(() {
          _file = imagefile;
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  Future<dynamic> uploadt_image(File _image) async {
    var request = await http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/set_image"));
    Map<String, String> headers = {
      "content-type": "application/json",
      "Connection": "keep-alive",
      "Accept-Encoding": " gzip"
    };
    request.headers.addAll(headers);
    // request.files.add(picture);
    request.fields['cid'] = code.toString();
    request.files.add(
      await http.MultipartFile.fromPath(
        "image",
        _image.path,
      ),
    );
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);
  }

  String imageUrl = '';
  //get khan
  void Load_khan(String district) async {
    setState(() {});
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/khan?Khan_Name=${district}'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      setState(() {
        list_Khan = jsonData;
        id_khan = int.parse(list_Khan[0]['Khan_ID']);
      });
    }
  }

  var id_Sangkat;
  List<dynamic> list_sangkat = [];
  void Load_sangkat(String id) async {
    setState(() {});
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/sangkat?Sangkat_Name=${id}'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      setState(() {
        list_sangkat = jsonData;
        id_Sangkat = int.parse(list_sangkat[0]['Sangkat_ID']);
      });
    }
  }

  int i = 0;
  Future _asyncInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          insetPadding:
              EdgeInsets.only(top: 30, left: 10, right: 1, bottom: 20),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              child: LandBuilding(
                ID_khan: id_khan.toString(),
                // asking_price: asking_price,
                opt: opt,
                address: '${commune} / ${district}',
                list: (value) {
                  setState(() {
                    requestModelAuto.verbal = value;
                  });
                },
                landId: code.toString(),
                Avt: (value) {
                  a = value;
                  setState(() {});
                },
                opt_type_id: opt_type_id,
                check_property: 2,
                list_lb: (value) {
                  setState(() {
                    lb.addAll(value!);
                  });
                },
                ID_sangkat: '',
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle Label() {
    return TextStyle(color: kPrimaryColor, fontSize: 13);
  }

  TextStyle Name() {
    return TextStyle(
        color: kImageColor, fontSize: 14, fontWeight: FontWeight.bold);
  }

  TextStyle NameProperty() {
    return TextStyle(
        color: kImageColor, fontSize: 11, fontWeight: FontWeight.bold);
  }
}
