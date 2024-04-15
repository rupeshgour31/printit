import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/my_text_field.dart';
import 'package:printit_app/Common/validations_field.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:printit_app/Api/Request/WSGetNotesOrderSaveRequest.dart';
import 'package:printit_app/Api/Request/WSGetNotesViewRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:printit_app/LogIn/login.dart';
import 'package:printit_app/Notes/NotsView/notes_view_widgets.dart';
import 'package:printit_app/SelectPrintShop/select_print_shop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class NotesView extends StatefulWidget {
  final notes_id;
  NotesView({this.notes_id});

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  TextEditingController orderTitle = TextEditingController();
  var user_id;
  var get_print_type;
  var notesView;
  int getItemsNo = 0;
  int _itemCount = 0;
  String itemsColor = '';
  bool _isLoading = false;
  bool loginStatus = false;
  var getIndex = -1;
  var languageType;
  @override
  void initState() {
    super.initState();
    getNotesListAntCateg();
    getValuesSF();
  }

  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginStatus = prefs.getBool('isLoggedIn') ?? false;
    var getLang = json.decode(prefs.getString('language_select'));
    languageType = getLang ?? 'english';
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

  choosePaperQuantity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginStatus = prefs.getBool('isLoggedIn') ?? false;
    if (loginStatus == true) {
      setState(() {
        if (_itemCount == 0) {
          _itemCount++;
          getItemsNo = _itemCount;
        }
      });
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.only(top: 5.0, bottom: 50.0),
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[100],
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
                        size: 25,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Notes Quantites',
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
                        size: 25,
                        color: Colors.black,
                      ),
                      onPressed: () => {Navigator.pop(context)},
                    ),
                  ],
                ),
                // sheetQnt(context),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: (_itemCount == 1)
                                ? Colors.grey
                                : Color.fromRGBO(68, 84, 97, 1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                print("remove");
                                setState(() {
                                  if (_itemCount > 1) {
                                    HapticFeedback.lightImpact();
                                    quantityIncreaseDecrease('decrease');
                                    _itemCount--;
                                    getItemsNo = _itemCount;
                                  }
                                });
                              }),
                        ),
                        widthSizedBox(20.0),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: whiteColor,
                          ),
                          child: Center(
                            child: Text(
                              getItemsNo.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        widthSizedBox(20.0),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(68, 84, 97, 1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              quantityIncreaseDecrease('increase');
                              setState(() {
                                _itemCount++;
                                getItemsNo = _itemCount;
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      print('login first');
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
                        builder: (context) => Login(
                          comeFrom: 'asGuest',
                        ),
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
  }

  quantityIncreaseDecrease(String type) async {
    print("quantityIncreaseDecrease $type");

    setState(() {});
  }

  colorTextShow(getValue) {
    if (getValue == 0) {
      return 'Colored';
    } else if (getValue == 1) {
      return 'Black and White';
    } else {
      return '';
    }
  }

  @override
  void getNotesListAntCateg() async {
    var otpRequest = WSGetNotesViewRequest(
      endPoint: APIManager.endpoint,
      notesID: widget.notes_id,
    );
    await APIManager.performRequest(otpRequest, showLog: true);

    try {
      var dataResponse = otpRequest.response;
      print(dataResponse);
      if (dataResponse['success'] == true) {
        setState(
          () {
            notesView = dataResponse['data'];
          },
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void saveOrder(
    String totalPages,
    String id,
    itemsColorChoose,
  ) async {
    setState(() {
      _isLoading = true;
    });
    var print_type;
    setState(() {
      if (get_print_type == 'local_print') {
        print_type = '1';
      } else {
        print_type = '2';
      }
    });
    var otpRequest = WSGetNotesOrderSaveRequest(
      endPoint: APIManager.endpoint,
      projectName: orderTitle.text,
      notesId: id,
      totalPages: totalPages,
      serviceType: print_type,
      userId: user_id,
      copyNumber: getItemsNo.toString(),
      color: 'black_and_white',
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print(dataResponse);
      if (dataResponse['success'] == true) {
        print('notes page printeries show ${dataResponse}');
        setState(() {
          orderTitle.clear();
          _isLoading = false;
          getItemsNo = 1;
          getIndex = -1;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectPrintShop(
              comeFrom: 'notes',
              orderId: dataResponse['order_id'],
            ),
          ),
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        languageType == 'arabic' ? 'ملاحظات' : 'Notes',
        context,
        IconButton(
          icon: Icon(
            Icons.home_outlined,
            size: 28.0,
            color: whiteColor,
          ),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeName,
            (Route<dynamic> route) => false,
            arguments: {'print_type': get_print_type},
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
            child: Padding(
              padding: EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                top: MediaQuery.of(context).size.height * 0.22,
              ),
              child: singleNotesView(
                context,
                notesView,
                orderTitle,
                saveOrder,
                _itemCount,
                itemsColor,
                quantityIncreaseDecrease,
                choosePaperQuantity,
              ),
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
        // CircularProgressIndicator(),
      ),
    );
  }

  final formKey = GlobalKey<FormState>();

  Widget singleNotesView(
    context,
    notesView,
    orderTitle,
    saveOrder,
    _itemCount,
    itemsColor,
    quantityIncreaseDecrease,
    choosePaperQuantity,
  ) {
    return notesView == null
        ? Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.43,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: whiteColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150.0,
                            height: 150.0,
                            child: Image.network(
                              notesView['image'],
                              fit: BoxFit.fill,
                            ),
                          ),
                          widthSizedBox(25.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notesView['cat'] ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                ),
                              ),
                              heightSizedBox(10.0),
                              Text(
                                notesView['name'] ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Nunito',
                                  fontSize: 15.0,
                                ),
                              ),
                              heightSizedBox(10.0),
                              Text(
                                notesView['total_pages'] ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Nunito',
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        notesView['description'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Nunito',
                        ),
                        maxLines: 9,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  verticalDivider(true, 350.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 180.0, right: 10),
                    child: GestureDetector(
                      onTap: () => choosePaperQuantity(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(top: 5.0),
                            height: 50.0,
                            width: 115.0,
                            child: Text(
                              getItemsNo == 0 ? "" : getItemsNo.toString(),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                                fontFamily: 'Nunito',
                                decoration: TextDecoration.none,
                              ),
                              maxLines: 3,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          widthSizedBox(10.0),
                          InkWell(
                            onTap: () => choosePaperQuantity(),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(13.0),
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: whiteColor,
                              ),
                              child: Image.asset(
                                'assets/icons/designIcon.png',
                                color: Colors.black,
                              ),
                            ),
                          ),
                          widthSizedBox(10.0),
                          GestureDetector(
                            onTap: () => choosePaperQuantity(),
                            child: Container(
                              width: 100,
                              child: Text(
                                'NUMBER OF\nCOPIES',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: whiteColor,
                                  fontFamily: 'Nunito',
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 3,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 65.0, right: 10),
                    child: GestureDetector(
                      onTap: () => choosePaperColor(
                        context,
                        itemsColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            height: 50.0,
                            width: 115.0,
                            child: Text(
                              colorTextShow(getIndex) ?? '',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                                fontFamily: 'Nunito',
                                decoration: TextDecoration.none,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          widthSizedBox(10.0),
                          widthSizedBox(10.0),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 250.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/cta_button_active_white.png',
                        ),
                        GestureDetector(
                          onTap: () {
                            if (getItemsNo > 0) {
                              showPopup(
                                context,
                                Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    height: 320,
                                    padding: EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () =>
                                                  Navigator.of(context).pop(),
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
                                              : 'SAVE THIS \n PROJECT',
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
                                        Form(
                                          key: formKey,
                                          child: AllInputDesign(
                                            outlineInputBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                              ),
                                            ),
                                            enabledBorderRadius:
                                                BorderRadius.circular(100),
                                            focusedBorderRadius:
                                                BorderRadius.circular(100),
                                            key: Key("title"),
                                            cursorColor: Colors.black,
                                            textStyleColors: Colors.black,
                                            controller: orderTitle,
                                            fillColor: Colors.white,
                                            hintText: 'Title',
                                            validatorFieldValue: 'Title',
                                            validator: validateTitle,
                                            keyBoardType: TextInputType.name,
                                          ),
                                        ),
                                        heightSizedBox(15.0),
                                        Button(
                                          buttonName: languageType == 'arabic'
                                              ? 'حفظ ومتابعة'
                                              : 'SAVE AND CONTINUE',
                                          color: Color(0xff2995cc),
                                          btnWidth: 260.0,
                                          onPressed: () {
                                            if (formKey.currentState
                                                .validate()) {
                                              Navigator.of(context).pop();
                                              saveOrder(
                                                notesView['total_pages'],
                                                notesView['id'],
                                                itemsColor,
                                              );
                                            }
                                            ;
                                          },
                                          decoration:
                                              BorderRadius.circular(15.0),
                                        ),
                                        heightSizedBox(15.0),
                                        Button(
                                          buttonName: languageType == 'arabic'
                                              ? 'إزالة'
                                              : 'DELETE',
                                          color: whiteColor,
                                          btnWidth: 180.0,
                                          borderColor: Color(0xffd50880),
                                          textColor: Color(0xffd50880),
                                          onPressed: () => Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            HomePage.routeName,
                                            (Route<dynamic> route) => false,
                                            arguments: {
                                              'print_type': get_print_type
                                            },
                                          ),
                                          decoration:
                                              BorderRadius.circular(15.0),
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
                                    padding: EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () =>
                                                  Navigator.of(context).pop(),
                                              child: Icon(
                                                Icons.close,
                                                size: 30,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                            height: 200.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                'Order It',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontFamily: 'Nunito',
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  List optionList = [
    {'id': '1', 'name': 'Colored'},
    {'id': '2', 'name': 'Black and White'},
  ];
  final _scrollController = FixedExtentScrollController();
  static const double _itemHeight = 30;
  choosePaperColor(
    context,
    itemsColor,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginStatus = prefs.getBool('isLoggedIn') ?? false;
    if (loginStatus == true) {
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
                  // print("onItemTapCallback index: $index and offset $xOffset");

                  // Navigator.pop(context);
                  // // selectedOptions[optionIndex] = optionList[index];
                  // getIndex = index;
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
                      getIndex = index;
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      // builder: (context, index) => _child(index),
                      builder: (BuildContext context, int index) {
                        if (index < 0 || index >= optionList.length) {
                          return null;
                        }
                        return Text(
                          optionList[index]["name"],
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                          ),
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
                      setState(() {
                        getIndex == 0 ? optionList[0] : optionList[getIndex];
                      });
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
            print('ModelSheet complete'),
            print(getIndex),
          });

      this.setState(() {});
    } else {
      print('login first');
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
    // selectedOptions[optionIndex] = {
    //   "id": "",
    //   "name": model.itemsCount.toString()
    // };
    // setState(() {});
  }
}
