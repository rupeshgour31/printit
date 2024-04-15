import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:printit_app/Api/Request/WSSaveQuickPrintOrderRequest.dart';
import 'package:printit_app/Api/Request/WSSaveTranslationOrderRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/my_text_field.dart';
import 'package:printit_app/Common/validations_field.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:printit_app/LogIn/login.dart';
import 'package:printit_app/OrderDetails/order_details.dart';
import 'package:printit_app/Poster/poster_model.dart';
import 'package:printit_app/Poster/poster_widgets.dart';
import 'package:printit_app/SelectPrintShop/select_print_shop.dart';
import 'package:provider/provider.dart';
import 'package:printit_app/Api/Request/WSGetPrintOptionsRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Poster extends StatefulWidget {
  @override
  final String printType;

  const Poster({Key key, this.printType}) : super(key: key);

  _PosterState createState() => _PosterState();
}

class _PosterState extends State<Poster> {
  var currentSelectedIndex = -1;
  String selectedPaperType = "";
  String selectedPaperSize = "";

  List<Map> posterPrintSelections = [
    {
      'icon': 'assets/icons/paper_icon.png',
      'title': 'Paper Type',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperType'
    },
    {
      'icon': 'assets/icons/size_icon.png',
      'title': 'Paper Size',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperSize'
    },
    {
      'icon': 'assets/icons/design_icon.png',
      'title': 'Design',
      'onPress': '/designPage',
      'type': 'PaperDesign'
    },
    {
      'icon': 'assets/icons/designIcon.png',
      'title': 'Number of Copies',
      'onPress': 'chooseQnantity',
      'type': 'PaperQuantity'
    }
  ];

  List<Map> bannerPrintSelections = [
    {
      'icon': 'assets/icons/paper_icon.png',
      'title': 'Paper Type',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperType'
    },
    {
      'icon': 'assets/icons/size_icon.png',
      'title': 'Width',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperWidth'
    },
    {
      'icon': 'assets/icons/design_icon.png',
      'title': 'Design',
      'onPress': '/designPage',
      'type': 'PaperDesign'
    },
    {
      'icon': 'assets/icons/designIcon.png',
      'title': 'Number of Copies',
      'onPress': 'chooseQnantity',
      'type': 'PaperQuantity'
    }
  ];

  List<Map> flyerPrintSelections = [
    {
      'icon': 'assets/icons/paper_icon.png',
      'title': 'Paper Type',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperType'
    },
    {
      'icon': 'assets/icons/size_icon.png',
      'title': 'Paper Size',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperSize'
    },
    {
      'icon': 'assets/icons/size_icon.png',
      'title': 'Paper Sides',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperSide'
    },
    {
      'icon': 'assets/icons/design_icon.png',
      'title': 'Design',
      'onPress': '/designPage',
      'type': 'PaperDesign'
    },
    {
      'icon': 'assets/icons/designIcon.png',
      'title': 'Number of Copies',
      'onPress': 'chooseQnantity',
      'type': 'PaperQuantity'
    }
  ];

  List<Map> quickPrintSelections = [
    {
      'icon': 'assets/icons/paper_icon.png',
      'title': 'Paper Type',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperType'
    },
    {
      'icon': 'assets/icons/size_icon.png',
      'title': 'Paper Size',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperSize'
    },
    {
      'icon': 'assets/icons/size_icon.png',
      'title': 'Color',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperColor'
    },
    {
      'icon': 'assets/icons/design_icon.png',
      'title': 'Document',
      'onPress': '/designPage',
      'type': 'PaperDocument'
    },
    {
      'icon': 'assets/icons/size_icon.png',
      'title': 'Binding',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperBinding'
    },
    {
      'icon': 'assets/icons/designIcon.png',
      'title': 'Number of Copies',
      'onPress': 'chooseQnantity',
      'type': 'PaperQuantity'
    }
  ];

  List<Map> rollupPrintSelections = [
    {
      'icon': 'assets/icons/paper_icon.png',
      'title': 'Paper Type',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperType'
    },
    {
      'icon': 'assets/icons/size_icon.png',
      'title': 'Paper Size',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'PaperSize'
    },
    {
      'icon': 'assets/icons/design_icon.png',
      'title': 'Design',
      'onPress': '/designPage',
      'type': 'PaperDesign'
    },
    {
      'icon': 'assets/icons/designIcon.png',
      'title': 'Number of Copies',
      'onPress': 'chooseQnantity',
      'type': 'PaperQuantity'
    }
  ];

  List<Map> translateSelections = [
    {
      'icon': 'assets/icons/paper_icon.png',
      'title': 'Translation Type',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'TranslateType'
    },
    {
      'icon': 'assets/icons/size_icon.png',
      'title': 'From',
      'onPress': 'selectPaperTypeBottomSheet',
      'type': 'TranslateFrom'
    },
    {
      'icon': 'assets/icons/design_icon.png',
      'title': 'To',
      'onPress': '/designPage',
      'type': 'TranslateTo'
    },
    {
      'icon': 'assets/icons/designIcon.png',
      'title': 'Document',
      'onPress': 'chooseQnantity',
      'type': 'TranslateDocument'
    }
  ];

  List paperType = [];

  List paperSize = [];

  List paperSides = [];

  List bannerWidth = [];
  List translationTypes = [];

  List translationLanguages = [];

  List printColors = [];
  var user_id;
  var get_print_type;
  var print_type_get;
  var print_type_no;
  var languageType;

  List printingSide = [];
  List bindingOptions = [];

  List selectedOptions = [
    {"id": "", "name": ""},
    {"id": "", "name": ""},
    {"id": "", "name": ""},
    {"id": "", "name": ""},
    {"id": "", "name": ""},
    {"id": "", "name": ""},
    {"id": "", "name": ""},
  ];

  List<Map> currentPrintOptions = [];
  bool _saving = false;
  bool _isLoading = false;
  var loginStatus;
  Color screenColor = Colors.lightBlue;
  var selectedPrintImage = "assets/images/cta_button_active_blue.png";

  getDropdownOptions() async {
    print('rupesh GET INITSTATE RETURN');
    setState(() {
      _isLoading = true;
    });
    var dropDownReq = WSGetPrintOptionsRequest(
      endPoint: APIManagerForm.endpoint,
      order_type: print_type_get,
      print_type: print_type_no,
    );
    await APIManagerForm.performRequest(dropDownReq, showLog: true);
    try {
      var dataResponse = dropDownReq.response;
      paperType = dataResponse["paper_type"];
      paperSize = dataResponse["paper_size"];
      paperSides = dataResponse["printing_side"];
      bannerWidth = dataResponse["banner_size"];
      translationTypes = dataResponse["translation_types"];
      translationLanguages = dataResponse["translation_lang"];
      printColors = dataResponse["color"];
      bindingOptions = dataResponse["binding"];
      setState(() {
        _isLoading = false;
        print_type_get = '';
        print_type_no = '';
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getValuesSF();
      await getDropdownOptions();
    });

    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginStatus = prefs.getBool('isLoggedIn') ?? false;
    if (prefs.containsKey('language_select')) {
      var getLang = json.decode(prefs.getString('language_select'));
      languageType = getLang ?? 'english';
    } else {
      print('LOG TABBBB');
    }

    if (loginStatus) {
      setState(
        () {
          user_id = json.decode(prefs.getString('login_user_id'));
          get_print_type = json.decode(prefs.getString('set_print_type'));
        },
      );
    } else {
      this.setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print('sdfdsfdsfdsfkljf ${languageType}');
    final Map<String, Object> rcvdData =
        ModalRoute.of(context).settings.arguments;
    var currentPrintType = rcvdData['printType'];
    print_type_get = rcvdData['order_type'];
    print_type_no = rcvdData['order_type_no'];
    var imageName = rcvdData['imageName'];
    var bluebarTopPosition = MediaQuery.of(context).size.height * 0.28;
    var blurbarHeight = 70.0;
    var optionImageHeight = 150.0;
    var optionImageWidth = (currentPrintType == "Translate" ||
            currentPrintType == 'ترجمة' ||
            currentPrintType == "Quick Print" ||
            currentPrintType == 'طباعة سريعة')
        ? 150.0
        : 230.0;
    var optionImageYPosition =
        bluebarTopPosition + blurbarHeight - optionImageHeight;

    if (currentPrintType == "Poster" || currentPrintType == 'بوستر') {
      screenColor = Colors.lightBlue;
      currentPrintOptions = posterPrintSelections;
      selectedPrintImage = "assets/images/cta_button_active_blue.png";
    } else if (currentPrintType == "Flyer" || currentPrintType == 'فلاير') {
      screenColor = Colors.lightBlue;
      currentPrintOptions = flyerPrintSelections;
      selectedPrintImage = "assets/images/cta_button_active_blue.png";
    } else if (currentPrintType == "Banner" || currentPrintType == 'بانير') {
      screenColor = Colors.lightBlue;
      currentPrintOptions = bannerPrintSelections;
      selectedPrintImage = "assets/images/cta_button_active_blue.png";
    } else if (currentPrintType == "Rollup" || currentPrintType == 'رول أب') {
      screenColor = Colors.lightBlue;
      currentPrintOptions = rollupPrintSelections;
      selectedPrintImage = "assets/images/cta_button_active_blue.png";
    } else if (currentPrintType == "Quick Print" ||
        currentPrintType == 'طباعة سريعة') {
      screenColor = Colors.yellow;
      currentPrintOptions = quickPrintSelections;
      selectedPrintImage = "assets/images/cta_button_active_yellow.png";
    } else if (currentPrintType == "Translate" || currentPrintType == 'ترجمة') {
      screenColor = Color.fromRGBO(213, 8, 128, 1);
      currentPrintOptions = translateSelections;
      selectedPrintImage = "assets/images/cta_button_active_magenta.png";
    }

    return Consumer<PosterModel>(
      builder: (context, model, _) {
        return MediaQuery(
          data: mediaText(context),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Padding(
                padding: EdgeInsets.only(top: 65.0, left: 20.0, right: 20.0),
                child: AppBar(
                  backgroundColor: Colors.black45,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_outlined,
                            color: whiteColor,
                          ),
                          onPressed: () {
                            model.resetItemCount();
                            model.imageSavePath = '';
                            model.image = null;
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          currentPrintType,
                          style: TextStyle(
                            fontSize: 23.0,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            color: whiteColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.home_outlined,
                            size: 28.0,
                            color: whiteColor,
                          ),
                          onPressed: () => {
                            model.resetItemCount(),
                            model.imageSavePath = '',
                            model.image = null,
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              HomePage.routeName,
                              (Route<dynamic> route) => false,
                              arguments: {'print_type': get_print_type},
                            )
                          },
                        )
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                ),
              ),
            ),
            extendBodyBehindAppBar: true,
            body: LoadingOverlay(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/img1.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        height: optionImageYPosition +
                            optionImageHeight +
                            (currentPrintOptions.length * 140) +
                            ((currentSelectedIndex == -1) ? 250 : 330),
                      ),
                      buildGoView(context, model, currentPrintType),
                      Positioned(
                        top: bluebarTopPosition,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: Container(
                          margin: EdgeInsets.only(),
                          height: blurbarHeight,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: screenColor,
                          ),
                        ),
                      ),
                      Positioned(
                        top: optionImageYPosition,
                        left: MediaQuery.of(context).size.width / 2 -
                            optionImageWidth / 2,
                        child: SizedBox(
                          height: optionImageHeight,
                          width: optionImageWidth,
                          child: Image.asset(
                            imageName,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      for (int index = 0;
                          index < currentPrintOptions.length;
                          index++)
                        printOptionView(
                            index,
                            optionImageYPosition + optionImageHeight,
                            context,
                            model,
                            currentPrintType),
                      for (int index = 0;
                          index < currentPrintOptions.length;
                          index++)
                        showSelectedOption(
                          optionImageYPosition +
                              optionImageHeight +
                              145 * (index + 1),
                          selectedOptions,
                          context,
                          index,
                          currentPrintType,
                        ),
                      Container(
                        child: CustomPaint(
                          size: Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                          painter: PathPainter(
                            currentSelectedIndex: currentSelectedIndex,
                            initialYPosition:
                                optionImageYPosition + optionImageHeight,
                            optionLength: currentPrintOptions.length,
                            strokeColor: screenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isLoading: _isLoading,
              opacity: 0.1,
              progressIndicator: Center(
                child: Container(
                  decoration: new BoxDecoration(
                    color: Color(0xff001b29),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  width: 100.0,
                  height: 100.0,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new SizedBox(
                        height: 45.0,
                        width: 45.0,
                        child: new CircularProgressIndicator(
                          value: null,
                          strokeWidth: 5.0,
                        ),
                      ),
                      heightSizedBox(10.0),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: whiteColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget showSelectedOption(
    double topPosition,
    selectedOption,
    BuildContext context,
    index,
    getCurrentPrintType,
  ) {
    return Positioned(
      top: topPosition,
      left: 2,
      right: (index == currentSelectedIndex)
          ? 0
          : MediaQuery.of(context).size.width / 2 + 40,
      child: SizedBox(
        height: 20.0,
        width: MediaQuery.of(context).size.width - 100,
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            selectedOption[index]['name'].toString().toUpperCase(),
            textAlign: (index == currentSelectedIndex)
                ? TextAlign.center
                : TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Nunito',
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  final formKey = GlobalKey<FormState>();

  Widget buildGoView(BuildContext context, model, currentPrintTypeGet) {
    return Positioned(
      width: 280,
      left: MediaQuery.of(context).size.width / 2 - 140,
      bottom: 0,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(
            currentSelectedIndex == -1
                ? "assets/images/buttonBase.png"
                : selectedPrintImage,
            fit: BoxFit.fill,
            alignment: Alignment.center,
          ),
          GestureDetector(
            onTap: () {
              customPrintAPI();
              if (printAble(currentPrintTypeGet) == true) {
                showPopup(
                  context,
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 320,
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            languageType == 'arabic'
                                ? 'احفظ هذا المشروع'
                                : 'SAVE THIS\nPROJECT',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Nunito',
                              decoration: TextDecoration.none,
                            ),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                          heightSizedBox(15.0),
                          Form(
                            key: formKey,
                            child: AllInputDesign(
                              outlineInputBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              enabledBorderRadius: BorderRadius.circular(100),
                              focusedBorderRadius: BorderRadius.circular(100),
                              key: Key("title"),
                              cursorColor: Colors.black,
                              textStyleColors: Colors.black,
                              controller: model.orderTitle,
                              fillColor: Colors.white,
                              hintText: 'Title',
                              validatorFieldValue: 'Title',
                              validator: validateTitle,
                              keyBoardType: TextInputType.name,
                            ),
                          ),
                          // ),
                          heightSizedBox(15.0),
                          Button(
                            buttonName: languageType == 'arabic'
                                ? 'حفظ ومتابعة'
                                : 'SAVE AND CONTINUE',
                            color: Color(0xff2995cc),
                            btnWidth: 260.0,
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                Navigator.of(context).pop();
                                saveOrders(
                                  context,
                                  formKey,
                                  model,
                                  currentPrintTypeGet,
                                );
                              }
                            },
                            decoration: BorderRadius.circular(15.0),
                          ),
                          heightSizedBox(15.0),
                          Button(
                            buttonName:
                                languageType == 'arabic' ? 'إزالة' : 'DELETE',
                            color: whiteColor,
                            btnWidth: 180.0,
                            borderColor: Color(0xffd50880),
                            textColor: Color(0xffd50880),
                            onPressed: () =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                              HomePage.routeName,
                              (Route<dynamic> route) => false,
                              arguments: {'print_type': get_print_type},
                            ),
                            decoration: BorderRadius.circular(15.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                showPopup(
                  context,
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 130,
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                              widthSizedBox(5.0),
                              Text(
                                'Alert',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontFamily: 'Nunito',
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          heightSizedBox(20.0),
                          Text(
                            'Please select all the fields.',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Nunito',
                              decoration: TextDecoration.none,
                            ),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Center(
                child: Text(
                  currentPrintTypeGet == 'Translate' ||
                          currentPrintTypeGet == 'ترجمة'
                      ? 'SEND IT'
                      : 'Print It',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: screenColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List takePrintAble = [];

  printAble(currentPrintTypeGet) {
    var length = takePrintAble.length;
    switch (currentPrintTypeGet) {
      case 'Quick Print':
        return length == 6 ? true : false;
        break;
      case 'Translate':
        return length == 4 ? true : false;
        break;
      case 'ترجمة':
        return length == 4 ? true : false;
        break;
      case 'Poster':
        return length == 4 ? true : false;
        break;
      case 'بوستر':
        return length == 4 ? true : false;
        break;
      case 'Flyer':
        return length == 5 ? true : false;
        break;
      case 'فلاير':
        return length == 5 ? true : false;
        break;
      case 'Banner':
        return length == 4 ? true : false;
        break;
      case 'بانير':
        return length == 4 ? true : false;
        break;
      case 'Rollup':
        return length == 4 ? true : false;
        break;
      case 'رول أب':
        return length == 4 ? true : false;
        break;
    }
  }

  customPrintAPI() {
    var paperTypeID = selectedOptions[0]["id"];
    var paperSizeID = selectedOptions[1]["id"];
    var paperQty = selectedOptions[3]["name"];
    print('ontap print it => ${takePrintAble}');
  }

  Widget printOptionView(
      index, beginYPosition, context, model, getCurrentPrintType) {
    print('get text show ${index}');
    print('get image upload ${beginYPosition}');
    print('get image upload ${model}');
    var iconRadius = 35.0;
    var optionGap = 70;

    var selectionGap = 0;
    if (currentSelectedIndex != -1 && index > currentSelectedIndex) {
      selectionGap = 80;
    }
    // setState(() {});
    return Positioned(
      top: beginYPosition +
          index * iconRadius * 2 +
          (index + 1) * optionGap +
          selectionGap,
      left: 0,
      child: GestureDetector(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          loginStatus = prefs.getBool('isLoggedIn') ?? false;
          if (loginStatus == true) {
            var optionType = currentPrintOptions[index]["type"];
            print('ontap get => ${optionType}');
            if (takePrintAble.contains(optionType) != true) {
              takePrintAble.add(optionType);
            }
            if (optionType == "PaperType") {
              selectOptionFromBottomSheet(context, paperType, index, model);
            } else if (optionType == "PaperSize") {
              selectOptionFromBottomSheet(context, paperSize, index, model);
            } else if (optionType == "PaperQuantity") {
              choosePaperQuantity(context, index, model, getCurrentPrintType);
            } else if (optionType == "PaperDesign") {
              Navigator.pushNamed(context, '/designPage', arguments: {
                'index': index,
                'selectedOptions': selectedOptions,
                'currentPrintType': getCurrentPrintType
              }).then((value) {
                this.setDesignName(model, getCurrentPrintType);
              });
            } else if (optionType == "PaperSide") {
              selectOptionFromBottomSheet(context, paperSides, index, model);
            } else if (optionType == "PaperWidth") {
              selectOptionFromBottomSheet(context, bannerWidth, index, model);
            } else if (optionType == "TranslateType") {
              selectOptionFromBottomSheet(
                  context, translationTypes, index, model);
            } else if (optionType == "TranslateTo") {
              var translateFrom = selectedOptions[1]["name"];
              var toLanguages = [];
              toLanguages.addAll(translationLanguages);

              var toIndex = translationLanguages.indexWhere(
                  (translate) => translate["name"] == translateFrom);
              if (toIndex != -1) {
                toLanguages.removeAt(toIndex);
              }
              selectOptionFromBottomSheet(context, toLanguages, index, model);
            } else if (optionType == "TranslateFrom") {
              var translateTo = selectedOptions[2]["name"];
              var fromLanguages = [];
              fromLanguages.addAll(translationLanguages);
              var fromIndex = translationLanguages
                  .indexWhere((translate) => translate["name"] == translateTo);
              if (fromIndex != -1) {
                fromLanguages.removeAt(fromIndex);
              }
              selectOptionFromBottomSheet(context, fromLanguages, index, model);
            } else if (optionType == "TranslateDocument") {
              // _openFileExplorer(translationLanguages, index);
              Navigator.pushNamed(context, '/designPage', arguments: {
                'index': index,
                'selectedOptions': selectedOptions,
                'currentPrintType': getCurrentPrintType
              }).then((value) {
                this.setDesignName(model, getCurrentPrintType);
              });
            } else if (optionType == "PaperDocument") {
              // _openFileExplorer(translationLanguages, index);
              Navigator.pushNamed(context, '/designPage', arguments: {
                'index': index,
                'selectedOptions': selectedOptions,
                'currentPrintType': getCurrentPrintType
              }).then((value) {
                this.setDesignName(model, getCurrentPrintType);
              });
            } else if (optionType == "PaperBinding") {
              selectOptionFromBottomSheet(
                  context, bindingOptions, index, model);
            } else if (optionType == "PaperColor") {
              selectOptionFromBottomSheet(context, printColors, index, model);
            }
            currentSelectedIndex = index;
          } else {
            showPopup(
              context,
              Material(
                color: Colors.transparent,
                child: Container(
                  height: 150,
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'To Continue ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Please Login',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                      heightSizedBox(15.0),
                      Button(
                        buttonName: 'GO TO LOGIN',
                        color: Color(0xff2995cc),
                        btnWidth: 220.0,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(comeFrom: 'asGuest'),
                            ),
                          );
                        },
                        decoration: BorderRadius.circular(15.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 2 - iconRadius - 10,
                child: Text(
                  (index == currentSelectedIndex)
                      ? currentPrintOptions[index]['title']
                          .toString()
                          .toUpperCase()
                      : "",
                  style: TextStyle(
                    fontSize: 18,
                    color: screenColor,
                    fontFamily: 'Nunito',
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10,
              ),
              padding: EdgeInsets.all(18.0),
              width: iconRadius * 2,
              height: iconRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: screenColor,
              ),
              child: Image.asset(
                currentPrintOptions[index]['icon'],
                color: getCurrentPrintType == "Quick Print" ||
                        getCurrentPrintType == 'طباعة سريعة'
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            widthSizedBox(20.0),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Container(
                height: 50,
                width: 135,
                child: Text(
                  (index == currentSelectedIndex)
                      ? ""
                      : currentPrintOptions[index]['title']
                          .toString()
                          .toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    color: screenColor,
                    fontFamily: 'Nunito',
                  ),
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setDesignName(model, getCurrentPrintType) {
    print('getCurrentPrintType == $getCurrentPrintType');
    var index = 2;
    if (getCurrentPrintType == 'Flyer' ||
        getCurrentPrintType == 'فلاير' ||
        getCurrentPrintType == 'Quick Print' ||
        getCurrentPrintType == 'طباعة سريعة' ||
        getCurrentPrintType == 'ترجمة' ||
        getCurrentPrintType == 'Translate') {
      index = 3;
    }

    selectedOptions[index] = {
      'id': '4',
      'name': model.image.path.split("/").last.toString(),
    };
    this.setState(() {});
  }

  String fileName;
  String path;
  Map<String, String> paths;
  List<String> extensions;
  bool isLoadingPath = false;

  void _openFileExplorer(
    optionList,
    int optionIndex,
  ) async {
    setState(() => isLoadingPath = true);
    try {
      path = await FilePicker.getFilePath(
          type: FileType.any, allowedExtensions: extensions);
      paths = null;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    print('Bhumit Path $path');
    if (path != null) {
      setState(() {
        isLoadingPath = false;
        fileName = path != null
            ? path.split('/').last
            : paths != null
                ? paths.keys.toString()
                : '...';

        selectedOptions[3] = {
          'id': '4',
          'name': path,
        };
      });
    } else {
      this.setState(() {
        isLoadingPath = false;
      });
    }
  }

  void showDescPopup(index, context, optionList) {
    showPopup(
      context,
      Material(
        color: Colors.transparent,
        child: Container(
          height: 230,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Text(
                optionList[index]["name"] ?? 'Info ',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontFamily: 'Nunito',
                  decoration: TextDecoration.none,
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
              heightSizedBox(20.0),
              Text(
                optionList[index]["description"] == ''
                    ? 'Description not available.'
                    : optionList[index]["description"],
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Nunito',
                  decoration: TextDecoration.none,
                ),
                maxLines: 3,
                textAlign: TextAlign.start,
              ),
              heightSizedBox(20.0),
              Button(
                buttonName: 'OK',
                color: Color(0xff2995cc),
                decoration: BorderRadius.circular(20.0),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  final _scrollController = FixedExtentScrollController();
  static const double _itemHeight = 30;

  selectOptionFromBottomSheet(
    BuildContext context,
    optionList,
    int optionIndex,
    model,
  ) async {
    print('get rreturn datan ${optionList}');

    var getIndex;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0),
              height: 200,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              child: ClickableListWheelScrollView(
                scrollController: _scrollController,
                itemHeight: _itemHeight,
                itemCount: optionList.length,
                // onItemTapCallback: (index, xOffset) {
                //   print("onItemTapCallback index: $index and offset $xOffset");
                //   var halfWidth = MediaQuery.of(context).size.width / 2;
                //   print(
                //       'halfWidth range ${(halfWidth + 70)} and end range ${(halfWidth + 120)}');
                //   if (xOffset > (halfWidth + 70) &&
                //       xOffset < (halfWidth + 120)) {
                //     showDescPopup(index, context, optionList);
                //   }
                //   // Navigator.pop(context);

                //   selectedOptions[optionIndex] = optionList[index];
                //   getIndex = index;
                //   print('lksfd${selectedOptions[optionIndex]}');
                //   print('lksfd${getIndex}');
                // },
                child: ListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  itemExtent: _itemHeight,
                  physics: FixedExtentScrollPhysics(),
                  magnification: 1.5,
                  useMagnifier: true,
                  squeeze: 0.8,
                  overAndUnderCenterOpacity: 0.5,
                  perspective: 0.01,
                  onSelectedItemChanged: (index) {
                    print("onSelectedItemChanged index: $index");
                    selectedOptions[optionIndex] = optionList[index];
                    getIndex = index;
                    HapticFeedback.lightImpact();
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    // builder: (context, index) => _child(index),
                    builder: (BuildContext context, int index) {
                      if (index < 0 || index >= optionList.length) {
                        return null;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widthSizedBox(50.0),
                          Text(
                            optionList[index]["name"],
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                              fontSize: 18.0,
                            ),
                          ),
                          widthSizedBox(25.0),
                          IconButton(
                            onPressed: () {
                              print('Bhumit Mehta');
                            },
                            icon: Icon(
                              Icons.info_outline_rounded,
                              size: 18.0,
                              color: Color(0xff2995cc),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: optionList.length,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    selectedOptions[optionIndex] =
                        getIndex == null ? optionList[0] : optionList[getIndex];
                  },
                  icon: Icon(
                    Icons.check,
                    size: 25.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).whenComplete(() => {
          print('ModelSheet complete ${selectedOptions}'),
        });

    this.setState(() {});
  }

  Widget _child(int index) {
    return SizedBox(
      height: _itemHeight,
      child: ListTile(
        leading: Icon(
            IconData(int.parse("0xe${index + 200}"),
                fontFamily: 'MaterialIcons'),
            size: 50),
        title: Text('Heart Shaker'),
        subtitle: Text('Description here'),
      ),
    );
  }

  choosePaperQuantity(context, optionIndex, model, getCurrentPrintType) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 50.0),
          height: 200,
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 244, 244, 1),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 28,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Sheet Quantites',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.check,
                      size: 28,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              model.sheetQnt(context),
            ],
          ),
        );
      },
    );

    selectedOptions[optionIndex] = {
      "id": "",
      "name": model.itemsCount.toString()
    };

    this.setState(() {});
  }

  saveOrders(context, formKey, model, getCurrentPrintType) async {
    print('getCurrentPrintType ===${getCurrentPrintType}');
    switch (getCurrentPrintType) {
      case 'Quick Print':
        return quickPrintOrderRequest(context, model, getCurrentPrintType);
        break;
      case 'طباعة سريعة':
        return quickPrintOrderRequest(context, model, getCurrentPrintType);
        break;
      case 'Translate':
        return translateOrderRequest(context, model, getCurrentPrintType);
        break;
      case 'ترجمة':
        return translateOrderRequest(context, model, getCurrentPrintType);
        break;
      case 'Poster':
      case 'Flyer':
      case 'Banner':
      case 'Rollup':
        return customPrintOrderRequest(context, model, getCurrentPrintType);
        break;
      case 'بوستر':
      case 'فلاير':
      case 'بانير':
      case 'رول أب':
        return customPrintOrderRequest(context, model, getCurrentPrintType);
        break;
    }
  }

  customPrintOrderRequest(context, model, getCurrentPrintType) async {
    setState(() {
      _isLoading = true;
    });
    var paperTypeID = selectedOptions[0]["id"];
    var paperSizeID = selectedOptions[1]["id"];
    var paperQty =
        getCurrentPrintType == 'Flyer' || getCurrentPrintType == 'فلاير'
            ? selectedOptions[4]["name"]
            : selectedOptions[3]["name"];
    var printing_side = selectedOptions[2]["id"];
    var print_type;
    var orderType;
    var paperSideID = "";
    var getWidth =
        getCurrentPrintType == 'Banner' || getCurrentPrintType == 'بانير'
            ? selectedOptions[1]["id"]
            : '';
    setState(
      () {
        if (get_print_type == 'local_print') {
          orderType = '1';
        } else {
          orderType = '2';
        }
      },
    );
    setState(
      () {
        if (getCurrentPrintType == 'Poster' || getCurrentPrintType == 'بانير') {
          print_type = '1';
        } else if (getCurrentPrintType == 'Flyer' ||
            getCurrentPrintType == 'فلاير') {
          print_type = '2';
          paperSideID = selectedOptions[2]["id"];
        } else if (getCurrentPrintType == 'Banner' ||
            getCurrentPrintType == 'بانير') {
          print_type = '4';
        } else if (getCurrentPrintType == 'Rollup' ||
            getCurrentPrintType == 'رول أب') {
          print_type = '3';
        }
      },
    );
    File imageFile = File(model.imageSavePath);

    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length(); //imageFile is your image file
    Map<String, String> headers = {
      "Accept": "application/json",
    }; // ignore this headers if there is no authentication

    // string to uri
    var uri = Uri.parse(
      "http://tenspark.com/printit/api/save_custom_print_order",
    );

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFileSign = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFileSign);

    //add headers
    request.headers.addAll(headers);
    //adding params
    request.fields['user_id'] = user_id;
    request.fields['project_name'] = model.orderTitle.text;
    request.fields['print_type'] = print_type;
    request.fields['paper_type'] = paperTypeID;
    request.fields['paper_size'] = paperSizeID;
    request.fields['width'] = getWidth;
    // if (paperSideID != "") {
    //   request.fields['printing_side'] = paperSideID;
    // }
    request.fields['copy_number'] = paperQty;
    // if (getCurrentPrintType == 'Flyer') {
    request.fields['printing_side'] = printing_side;
    // }
    request.fields['order_type'] = orderType;

    // send
    var response = await request.send();

    print(response);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      Map valueMap = json.decode(value);
      print('order response valueMap ${valueMap}');
      // Navigator.of(context).pushNamed(
      //   OrderDetails.routeName,
      //   arguments: {'get': value},
      // ); // {"success":true,"data":"order saved","order_id":170}
      if (valueMap['success'] == true) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => OrderDetails(
        //       order_id: valueMap['order_id'],
        //     ),
        //   ),
        // );
        // Navigator.pushNamed(context, '/ordersPage');
        setState(() {
          model.orderTitle.clear();
          model.itemsCount = 1;
          model.imageSavePath = '';
          model.image = null;
          _isLoading = false;
          // selectedOptions = [];
          takePrintAble = [];
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectPrintShop(
              comeFrom: 'notes',
              orderId: valueMap['order_id'].toString(),
            ),
          ),
        );
      } else {
        var messages = valueMap['msg'];
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Message'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  widthSizedBox(8.0),
                  Flexible(
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      child: Text(
                        messages,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  quickPrintOrderRequest(context, model, getCurrentPrintType) async {
    setState(() {
      _isLoading = true;
    });
    var paperTypeID = selectedOptions[0]["id"];
    var paperSizeID = selectedOptions[1]["id"];
    var colorSelect = selectedOptions[2]["name"];
    var selecetDoc = selectedOptions[3]['name'];
    var bindingSelect = selectedOptions[4]["name"];
    var paperQty = selectedOptions[5]["name"];
    var print_type;
    setState(() {
      if (get_print_type == 'local_print') {
        print_type = '1';
      } else {
        print_type = '2';
      }
    });
    // File imageFile = File(selecetDoc);
    File imageFile = File(model.imageSavePath);

    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length(); //imageFile is your image file
    Map<String, String> headers = {
      "Accept": "application/json",
    }; // ignore this headers if there is no authentication

    // string to uri
    var uri =
        Uri.parse("http://tenspark.com/printit/api/save_quick_print_order");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFileSign = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFileSign);

    //add headers
    request.headers.addAll(headers);

    //adding params
    request.fields['user_id'] = user_id;
    request.fields['project_name'] = model.orderTitle.text;
    request.fields['print_type'] = print_type;
    request.fields['paper_type'] = paperTypeID;
    request.fields['paper_size'] = paperSizeID;
    request.fields['copy_number'] = paperQty;
    request.fields['order_type'] = print_type;
    request.fields['color'] = colorSelect;
    request.fields['binding'] = bindingSelect;

    // send
    var response = await request.send();
    print('order ${response}');
    response.stream.transform(utf8.decoder).listen((value) {
      Map valueMap = json.decode(value);
      print('order response valueMap ${valueMap}');
      // Navigator.of(context).pushNamed(
      //   OrderDetails.routeName,
      //   arguments: {'get': value},
      // ); // {"success":true,"data":"order saved","order_id":170}
      if (valueMap['success'] == true) {
        setState(() {
          model.orderTitle.clear();
          model.itemsCount = 1;
          model.imageSavePath = '';
          model.image = null;
          _isLoading = false;
          // selectedOptions = [];
          takePrintAble = [];
        });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => OrderDetails(
        //       order_id: valueMap['order_id'],
        //     ),
        //   ),
        // );

        // Navigator.pushNamed(context, '/ordersPage');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectPrintShop(
              comeFrom: 'notes',
              orderId: valueMap['order_id'].toString(),
            ),
          ),
        );
      } else {
        var messages = valueMap['data'];
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Message'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  widthSizedBox(5.0),
                  Flexible(
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      child: Text(
                        messages,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  translateOrderRequest(context, model, getCurrentPrintType) async {
    setState(() {
      _isLoading = true;
    });
    if (selectedOptions[1]["name"] == selectedOptions[2]["name"]) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Message'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                widthSizedBox(5.0),
                Flexible(
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    child: Text(
                      'Translation From and To field not be same.',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      var paperTypeID = selectedOptions[0]["id"];
      var paperSizeID = selectedOptions[1]["id"];
      var paperQty = selectedOptions[2]["name"];
      var selecetDoc = selectedOptions[3]['name'];
      var print_type;
      setState(() {
        if (get_print_type == 'local_print') {
          print_type = '1';
        } else {
          print_type = '2';
        }
      });
      print('lkdsf ${paperSizeID}');
      print('lkdsf ${paperQty}');

      // File imageFile = File(selecetDoc);
      File imageFile = File(model.imageSavePath);

      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length(); //imageFile is your image file
      Map<String, String> headers = {
        "Accept": "application/json",
      }; // ignore this headers if there is no authentication

      // string to uri
      var uri =
          Uri.parse("http://tenspark.com/printit/api/save_translation_order");

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFileSign = new http.MultipartFile(
          'trans_doc', stream, length,
          filename: basename(imageFile.path));

      // add file to multipart
      request.files.add(multipartFileSign);

      //add headers
      request.headers.addAll(headers);

      //adding params
      request.fields['user_id'] = user_id;
      request.fields['project_name'] = model.orderTitle.text;
      request.fields['trans_type'] = paperTypeID;
      request.fields['lang_from'] = paperSizeID;
      request.fields['lang_to'] = paperQty;
      request.fields['print_copy_type'] = 'hard_copy';
      request.fields['order_type'] = print_type;

      // send
      var response = await request.send();

      print(response);
      // listen for response
      response.stream.transform(utf8.decoder).listen(
        (value) {
          Map valueMap = json.decode(value);
          print('order response valueMap ${valueMap}');
          var projectNameGet = model.orderTitle.text;
          if (valueMap['success'] == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetails(
                  orderDetail: {
                    'order_type': '3',
                    'project_name': projectNameGet,
                  },
                  order_id: valueMap['order_id'],
                ),
              ),
            );
            setState(() {
              model.orderTitle.clear();
              model.itemsCount = 1;
              model.imageSavePath = '';
              model.image = null;
              _isLoading = false;
              // selectedOptions = [];
              takePrintAble = [];
            });
          } else {
            var messages = valueMap['data'];
            setState(() {
              _isLoading = false;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text('Message'),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      widthSizedBox(5.0),
                      Flexible(
                        child: Container(
                          height: 50.0,
                          width: double.infinity,
                          child: Text(
                            messages,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      );
    }
  }
}

class PathPainter extends CustomPainter {
  int currentSelectedIndex;
  double initialYPosition;
  int optionLength;
  Color strokeColor;

  PathPainter({
    this.currentSelectedIndex,
    this.initialYPosition,
    this.optionLength,
    this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    //Curve lines code
    var optionGap = 70;
    var iconRadius = 35.0;
    var currentPrintOption = 0;
    var selectionGap = 0;

    while (currentPrintOption < optionLength) {
      if (currentSelectedIndex != -1 &&
          currentPrintOption > currentSelectedIndex) {
        selectionGap = 80;
      }
      if (currentSelectedIndex != -1 &&
          currentPrintOption == currentSelectedIndex + 1) {
        currentPrintOption++;
        continue;
      }
      Offset optionBeginPoint = Offset(
        size.width / 2,
        initialYPosition +
            currentPrintOption * iconRadius * 2 +
            currentPrintOption * optionGap +
            selectionGap,
      );
      Offset optionEndPoint = Offset(
        size.width / 2,
        initialYPosition +
            currentPrintOption * iconRadius * 2 +
            (currentPrintOption + 1) * optionGap +
            selectionGap,
      );
      canvas.drawLine(optionBeginPoint, optionEndPoint, paint);
      currentPrintOption++;
    }

    if (currentSelectedIndex != optionLength - 1) {
      Offset lastLineBeginPoint = Offset(
        size.width / 2,
        initialYPosition +
            currentPrintOption * iconRadius * 2 +
            currentPrintOption * optionGap +
            selectionGap,
      );
      Offset lastLineEndPoint = Offset(
        size.width / 2,
        initialYPosition +
            currentPrintOption * iconRadius * 2 +
            currentPrintOption * optionGap +
            selectionGap +
            50,
      );
      canvas.drawLine(lastLineBeginPoint, lastLineEndPoint, paint);
    }

    if (currentSelectedIndex != -1) {
      var topCurvePoint = initialYPosition +
          (currentSelectedIndex + 1) * iconRadius * 2 +
          (currentSelectedIndex + 1) * optionGap -
          iconRadius;
      var bottomCurveEndPoint = initialYPosition +
          (currentSelectedIndex + 2) * iconRadius * 2 +
          (currentSelectedIndex + 2) * optionGap +
          selectionGap -
          iconRadius;
      if (currentSelectedIndex == optionLength - 1) {
        bottomCurveEndPoint = bottomCurveEndPoint + iconRadius * 2;
      }

      var topCurveGap = (bottomCurveEndPoint - topCurvePoint) / 2;

      Offset horizontalTopStart = Offset(size.width / 2 + 35, topCurvePoint);
      Offset horizontalTopEnd = Offset(size.width / 2 + 120, topCurvePoint);
      canvas.drawLine(horizontalTopStart, horizontalTopEnd, paint);

      Offset horizontalBottomStart =
          Offset(size.width / 2 - 120, topCurvePoint + topCurveGap);
      Offset horizontalBottomEnd =
          Offset(size.width / 2 + 120, topCurvePoint + topCurveGap);
      canvas.drawLine(horizontalBottomStart, horizontalBottomEnd, paint);

      var controlPoint1 =
          Offset(size.width / 1.25 + 50, topCurvePoint + topCurveGap / 8);
      var controlPoint2 = Offset(
        size.width / 1.25 + 50,
        topCurvePoint + topCurveGap - topCurveGap / 8,
      );

      var path = Path();
      path.moveTo(horizontalTopEnd.dx, horizontalTopEnd.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        horizontalBottomEnd.dx,
        horizontalBottomEnd.dy,
      );
      canvas.drawPath(
        path,
        paint,
      );

      Offset horizontalLeftStart =
          Offset(size.width / 2 - 120, bottomCurveEndPoint);
      Offset horizontalLeftEnd;
      if (currentSelectedIndex == optionLength - 1) {
        horizontalLeftEnd = Offset(size.width / 2 - 60, bottomCurveEndPoint);
      } else {
        horizontalLeftEnd = Offset(size.width / 2 - 35, bottomCurveEndPoint);
      }

      canvas.drawLine(horizontalLeftStart, horizontalLeftEnd, paint);
      //Draw bottom curve

      var controlPointBottomCurve1 = Offset(size.width / 4 - 70,
          bottomCurveEndPoint + topCurveGap / 8 - topCurveGap);
      var controlPointBottomCurve2 =
          Offset(size.width / 4 - 70, bottomCurveEndPoint - topCurveGap / 8);
      var endPointBottomCurve =
          Offset(horizontalLeftStart.dx, bottomCurveEndPoint);

      var pathBottom = Path();
      pathBottom.moveTo(horizontalBottomStart.dx, horizontalBottomStart.dy);
      pathBottom.cubicTo(
        controlPointBottomCurve1.dx,
        controlPointBottomCurve1.dy,
        controlPointBottomCurve2.dx,
        controlPointBottomCurve2.dy,
        endPointBottomCurve.dx,
        endPointBottomCurve.dy,
      );

      canvas.drawPath(
        pathBottom,
        paint,
      );
    }

    //Draw bottom curve
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  bool hitTest(Offset position) {
    // _path - is the same one we built in paint() method;
    return false;
  }
}
