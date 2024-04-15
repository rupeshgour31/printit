import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:printit_app/AccountInfo/account_info_model.dart';
import 'package:printit_app/Api/Request/WSGetActiveOrdersListRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/drawer_menu.dart';
import 'package:printit_app/Dashboard/dashboard_widgets.dart';
import 'package:printit_app/Dashboard/service_select.dart';
import 'package:printit_app/OrderDetails/order_details_widgets.dart';
import 'package:printit_app/SelectProposal/SelectProposal.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'dart:ui' as ui show Image;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Dashboard extends StatefulWidget {
  // static const routeName = '/dashboard';
  final getPrintType;

  Dashboard({this.getPrintType});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var user_id;
  var languageType;
  List activeOrdersList = [];

  // var setPrintType;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  GlobalKey key = GlobalKey();

  bool isDrawerOpen = false;

//languageType == 'english' ?
  var printOptions = [
    {
      "icon": Icons.local_print_shop_outlined,
      "icons": "assets/icons/customPrintIcon.png",
      "name": "CUSTOM PRINT",
      "arabicName": 'مخصّصة',
      "Color": Colors.lightBlue,
      "SelectedGoButton": "assets/images/cta_button_active_blue.png"
    },
    {
      "icon": Icons.access_time_rounded,
      "icons": "assets/icons/quickPrintIcon.png",
      "name": "QUICK PRINT",
      "arabicName": 'طباعة سريعة',
      "Color": Colors.yellow,
      "SelectedGoButton": "assets/images/cta_button_active_yellow.png"
    },
    {
      "icon": Icons.translate,
      "icons": "assets/icons/translationIcon.png",
      "name": "TRANSLATION",
      "arabicName": 'ترجمة',
      "Color": Color.fromRGBO(213, 8, 128, 1),
      "SelectedGoButton": "assets/images/cta_button_active_magenta.png"
    },
    {
      "icon": Icons.note_add_outlined,
      "icons": "assets/icons/notesIcon.png",
      "name": "NOTES",
      "arabicName": 'ملاحظات',
      "Color": Colors.white,
      "SelectedGoButton": "assets/images/cta_button_active_white.png"
    },
  ];

  var selectedIndex = 10;
  var shouldStartTimer = true;

  void initState() {
    Future.delayed(Duration.zero, () async {
      await getValuesSF();
      await getActiveOrders();
    });
    super.initState();
  }

  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var getLang = json.decode(prefs.getString('language_select') ?? 'english');
    languageType = getLang == null ? 'english' : getLang;
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      setState(
        () {
          user_id = json.decode(prefs.getString('login_user_id'));
        },
      );
    } else {
      this.setState(() {});
    }
  }

  void getActiveOrders() async {
    //  progressHUD.state.show();
    var orderReq = WSGetActiveOrdersListRequest(
      endPoint: APIManager.endpoint,
      userId: user_id,
    );
    await APIManager.performRequest(orderReq, showLog: true);

    try {
      var dataResponse = orderReq.response;
      if (dataResponse['success'] == true) {
        progressHUD.state.dismiss();
        setState(() {
          activeOrdersList = dataResponse["data"];
        });
      }
      progressHUD.state.dismiss();
    } catch (e) {
      progressHUD.state.dismiss();
      print('Error: ${e.toString()}');
    }
  }

  // void storePrintType() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(
  //     'set_print_type',
  //     json.encode(
  //       setPrintType,
  //     ),
  //   );
  // }

  bool _enabled = false;
  final panelController = PanelController();
  bool showBtn = true;

  Widget buildCusTomPrintView(BuildContext context, int index) {
    var printOption = printOptions[index];
    var isCurrentIndexSelected = false;
    if (index == selectedIndex) {
      isCurrentIndexSelected = true;
    }
    print("Rendering print option ${printOptions[index]}");
    return GestureDetector(
      onTap: () {
        print("isDrawerOpen $isDrawerOpen");
        if (!isDrawerOpen) {
          setState(() {
            selectedIndex = index;
          });
        } else {
          print("Issue fixed");
        }
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Stack(
          overflow: Overflow.visible,
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            Positioned(
              width: 60,
              left: 30,
              child: AnimatedOpacity(
                opacity: (selectedIndex == 10) ? 1 : 0,
                child: Icon(
                  Icons.arrow_forward,
                  size: 40,
                  color: Colors.white,
                ),
                duration: const Duration(milliseconds: 250),
              ),
            ),
            AnimatedPositioned(
              left: isCurrentIndexSelected
                  ? MediaQuery.of(context).size.width / 1.25 + 9
                  : 100,
              // here 90 is (200(above container)-110(container which is animating))
              child: InkWell(
                onTap: () {},
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: printOption["Color"],
                  child: IconButton(
                    icon: Image.asset(
                      printOption["icons"],
                      color: printOption["name"] == 'NOTES'
                          ? Colors.black
                          : Colors.white,
                    ),
                    onPressed: () {
                      print('Selected Option $index');
                      print("isDrawerOpen $isDrawerOpen");

                      if (!isDrawerOpen) {
                        setState(() {
                          selectedIndex = index;
                        });
                      }

                      // if (shouldStartTimer) {
                      //   shouldStartTimer = false;
                      //   Timer(Duration(seconds: 2), () => ontapButton(index));
                      //
                      // }
                    },
                  ),
                ),
              ),
              duration: const Duration(seconds: 1),
              curve: Curves.bounceOut,
            ),
            AnimatedPositioned(
              left: isCurrentIndexSelected
                  ? MediaQuery.of(context).size.width / 2 - 50
                  : MediaQuery.of(context).size.width / 2 + 30,
              top: 10,
              child: Text(
                languageType == 'arabic'
                    ? printOption["arabicName"]
                    : printOption["name"],
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    color: (isCurrentIndexSelected)
                        ? printOption["Color"]
                        : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              duration: const Duration(seconds: 1),
              curve: Curves.bounceOut,
            ),
          ],
        ),
      ),
    );
  }

  bool openActiveContainer = false;

  Widget activeOrderView({orderArray}) {
    int trendIndex = orderArray
        .indexWhere((f) => f['progress_status'] == 'proposal_accepted');
    print('sfjdsfd ${trendIndex}');
    return AnimatedPositioned(
      bottom: 0,
      duration: const Duration(milliseconds: 100),
      left: 0,
      right: 0,
      top: openActiveContainer
          ? MediaQuery.of(context).size.height / 2 - 50
          : MediaQuery.of(context).size.height / 1.12,
      // child: Container(
      //   decoration: BoxDecoration(
      //     color: Colors.blue,
      //     borderRadius: BorderRadius.only(
      //       topRight: Radius.circular(40.0),
      //       topLeft: Radius.circular(40.0),
      //     ),
      //   ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            decoration: BoxDecoration(
              color: Color(0xff2995cc),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                topLeft: Radius.circular(40.0),
              ),
            ),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      openActiveContainer == true
                          ? openActiveContainer = false
                          : openActiveContainer = true;
                    });
                  },
                  child: Center(
                    child: Image.asset(
                      'assets/icons/printt_houses_icon_bucket.png',
                    ),
                  ),
                ),
              ),
              trendIndex != -1
                  ? Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 10.0,
                      width: 10.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Text(''),
            ],
          ),
          (openActiveContainer == false)
              ? Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        openActiveContainer == true
                            ? openActiveContainer = false
                            : openActiveContainer = true;
                      });
                    },
                    child: Text(
                      'Tap for orders updates',
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(top: 60.0),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: orderArray.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(
                          "Bhumit Mehta ${orderArray[index]['progress_status']}");
                      return Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 20.0,
                              left: 30.0,
                              right: 30.0,
                            ),
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color(0xff2086ba),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: ListTile(
                              leading: Container(
                                height: 40.0,
                                width: 40.0,
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: whiteColor,
                                ),
                                child: selectTypedImage(
                                  orderArray[index]['order_type'],
                                ),
                              ),
                              title: Text(
                                orderArray[index]['project_name'],
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: whiteColor,
                                ),
                              ),
                              subtitle: Text(
                                orderArray[index]['trans_proposal_count'] != '0' && orderArray[index]['progress_status'] == 'proposal_received'
                                    ? '${orderArray[index]['trans_proposal_count']} Proposals Received' : getOrderStatusString(orderArray[index]['progress_status']),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_outlined,
                                  size: 37.0,
                                  color: whiteColor,
                                ),
                                onPressed: () => {
                                  print("Priyanka ${orderArray[index]['progress_status']}"),
                                  if (orderArray[index]['progress_status'] ==
                                      "awaiting_for_translation_proposals" || orderArray[index]['progress_status'] == 'proposal_received')
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SelectProposal(
                                            orderArray[index],
                                          ),
                                        ),
                                      )
                                    }
                                  else
                                    {
                                      Navigator.pushNamed(
                                          context, '/orderStatus',
                                          arguments: {
                                            'orderID': orderArray[index]
                                                ["id"],
                                            'OrderStatus' : getOrderStatusString(orderArray[index]['progress_status'])
                                          })
                                    }
                                },
                              ),
                            ),
                          ),
                          orderArray[index]['trans_proposal_count'] == '0'
                              ? Text('')
                              : Container(
                                  margin: EdgeInsets.only(
                                    left: 35.0,
                                    top: 5.0,
                                  ),
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                )
                        ],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  String getOrderStatusString(String orderStatus) {
    if(orderStatus == "being_printed") {
      return "Being Printed";
    }
    else if(orderStatus == "ready_for_pickup") {
      return "Ready For Pickup";
    }
    else if(orderStatus == "delivered") {
      return "Delivered";
    }
    else if(orderStatus == "waiting_for_proposal") {
      return "Waiting For Proposals";

    }
    else if(orderStatus == "proposal_received") {
      return "Proposal Received";
    }
    else if(orderStatus == "saved") {
      return "Saved";

    }
    else if(orderStatus == "awaiting_for_translation_proposals") {
      return "Waiting For Proposals";
    }
    else if(orderStatus == "proposal_accepted") {
      return "Proposal Accepted";

    }
    else if(orderStatus == "ready_for_delivery") {
      return "Ready For Delivery";
    }
    else if(orderStatus == "New") {
        return "New";
    }
    else if(orderStatus == "New") {
      return "New";
    }
    return orderStatus;
  }

  Widget buildTopView(BuildContext context) {
    return Positioned(
      top: 30.0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceSelect(),
            ),
          );
        },
        child: Row(
          children: [
            SizedBox(
              width: 30.0,
            ),
            SizedBox(
              width: 150.0,
              child: Text(
                languageType == 'arabic'
                    ? 'اختر نوع الخدمة المطلوبة'
                    : 'Select \nA Printery',
                textDirection: TextDirection.ltr,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(
              width: 75.0,
            ),
            CircleAvatar(
              key: key,
              radius: 35,
              backgroundColor: Colors.white,
              child: Image.asset(
                widget.getPrintType == 'express_print'
                    ? 'assets/icons/printHouse.png'
                    : 'assets/icons/printt_houses_icon4.png',
                height: 50.0,
                width: 50.0,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Timer _timer;
  ontapButton(selectedIndexValue) {
    if (selectedIndexValue == 0) {
      Navigator.pushNamed(context, '/customPrint');
    } else if (selectedIndexValue == 1) {
      Navigator.pushNamed(context, '/poster', arguments: {
        "printType": languageType == 'arabic' ? 'طباعة سريعة' : "Quick Print",
        'order_type': '2',
        'order_type_no': '',
        "imageName": 'assets/images/quickPrint.png'
      });
    } else if (selectedIndexValue == 2) {
      Navigator.pushNamed(context, '/poster', arguments: {
        "printType": languageType == 'arabic' ? 'ترجمة' : "Translate",
        'order_type': '3',
        'order_type_no': '',
        "imageName": 'assets/images/translationTitle.png'
      });
    } else if (selectedIndexValue == 3) {
      Navigator.pushNamed(
        context,
        '/notes_list',
      );
    }

    // Timer(
    //     Duration(seconds: 1),
    //     () => this.setState(() {
    //           selectedIndex = 10;
    //           shouldStartTimer = true;
    //         }));
  }

  goBtnColor(int selectIndex) {
    switch (selectIndex) {
      case 0:
        return Colors.lightBlue;
        break;
      case 1:
        return Colors.yellow;
        break;
      case 2:
        return Color.fromRGBO(213, 8, 128, 1);
        break;
      case 3:
        return whiteColor;
        break;
      default:
        return Colors.grey;
        break;
    }
  }

  Widget buildGoView(BuildContext context) {
    var imageName = (selectedIndex == 10)
        ? "assets/images/buttonBase.png"
        : printOptions[selectedIndex]["SelectedGoButton"];
    return Positioned(
      width: 280,
      left: (MediaQuery.of(context).size.width - 280) / 2,
      bottom: (Platform.isIOS) ? -58 : -20,
      child: GestureDetector(
        onTap: () {
          if (!isDrawerOpen) {
            ontapButton(selectedIndex);
          } else {
            print("Go button blocked");
          }
        },
        child: Stack(
          children: [
            Image.asset(
              imageName,
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
            Positioned(
              width: 280,
              left: (Platform.isIOS) ? 0 : 0,
              bottom: 80,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Text(
                    languageType == 'arabic' ? 'اذهب' : 'GO',
                    style: TextStyle(
                      fontSize: 23.0,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w100,
                      color: goBtnColor(selectedIndex),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    var statusbarHeight = MediaQuery.of(context).padding.top;
    return Consumer<AccountInfoModel>(
      builder: (context, model, _) {
        return Stack(
          children: [
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)
                ..rotateY(isDrawerOpen ? -0.0 : 0),
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(isDrawerOpen ? 60 : 0.0),
                      image: DecorationImage(
                        image: AssetImage("assets/images/img1.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        title: Text(
                          languageType == 'arabic'
                              ? 'قم بالطباعة الآن'
                              : 'Print IT',
                        ),
                        centerTitle: true,
                        leading: isDrawerOpen
                            ? IconButton(
                                icon: Image.asset(
                                  'assets/icons/drawer.png',
                                  height: 30,
                                  width: 30.0,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      xOffset = 0;
                                      yOffset = 0;
                                      scaleFactor = 1;
                                      isDrawerOpen = false;
                                    },
                                  );
                                },
                              )
                            : IconButton(
                                icon: Image.asset(
                                  'assets/icons/drawer.png',
                                  height: 30,
                                  width: 30.0,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      xOffset = 280;
                                      yOffset = 150;
                                      scaleFactor = 0.65;
                                      isDrawerOpen = true;
                                    },
                                  );
                                },
                              ),
                      ),
                      body: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: SafeArea(
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height + 200,
                              ),
                              buildTopView(context),
                              buildGoView(context),
                              Column(
                                children: [
                                  heightSizedBox(180.0),
                                  buildCusTomPrintView(context, 0),
                                  buildCusTomPrintView(context, 1),
                                  widget.getPrintType == 'express_print'
                                      ? buildCusTomPrintView(
                                          context,
                                          2,
                                        )
                                      : Container(),
                                  buildCusTomPrintView(context, 3),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                      painter: PathPainter(
                        currentSelectedIndex: selectedIndex,
                        stautsbarHeight: MediaQuery.of(context).padding.top,
                        printType: widget.getPrintType,
                      ),
                    ),
                  ),
                  activeOrdersList.length != 0
                      ? activeOrderView(
                          orderArray: activeOrdersList,
                        )
                      : Container(),
                ],
              ),
            ),
            progressHUD,
          ],
        );
      },
    );
  }
}

class PathPainter extends CustomPainter {
  int currentSelectedIndex;
  double stautsbarHeight;
  String printType;

  PathPainter(
      {this.currentSelectedIndex, this.stautsbarHeight, this.printType});

  @override
  void paint(Canvas canvas, Size size) {
    var strokeColors = [
      Colors.lightBlue,
      Colors.yellow,
      Color.fromRGBO(213, 8, 128, 1),
      Colors.white,
    ];
    Color currentColor = Colors.blueGrey;
    print('currentSelectedIndex $currentSelectedIndex');
    if (currentSelectedIndex < strokeColors.length) {
      currentColor = strokeColors[currentSelectedIndex];
    }
    Paint paint = Paint()
      ..color = currentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    //Curve lines code

    var topCurvePoint = 125.0 + stautsbarHeight;
    var topCurveGap = 55.0;

    Offset optionTwoBeginPoint =
        Offset(size.width / 2, topCurvePoint + topCurveGap + 110);
    Offset optionThreeBeginPoint =
        Offset(size.width / 2, topCurvePoint + topCurveGap + 180);
    Offset optionFourBeginPoint =
        Offset(size.width / 2, topCurvePoint + topCurveGap + 250);
    Offset optionFourEndPoint =
        Offset(size.width / 2, topCurvePoint + topCurveGap + 320);
    Offset endingPoint = Offset(size.width / 2, size.height - 150);

    Offset horizontalTopStart = Offset(325, topCurvePoint);
    Offset horizontalTopEnd = Offset(size.width / 1.25 + 40, topCurvePoint);
    canvas.drawLine(horizontalTopStart, horizontalTopEnd, paint);

    Offset horizontalBottomStart =
        Offset(size.width / 2 + 20, topCurvePoint + topCurveGap);
    Offset horizontalBottomEnd =
        Offset(size.width / 1.25 + 40, topCurvePoint + topCurveGap);
    canvas.drawLine(horizontalBottomStart, horizontalBottomEnd, paint);

    var controlPoint1 =
        Offset(size.width / 1.25 + 65, topCurvePoint + topCurveGap / 8);
    var controlPoint2 = Offset(
        size.width / 1.25 + 65, topCurvePoint + topCurveGap - topCurveGap / 8);

    var path = Path();
    path.moveTo(horizontalTopEnd.dx, horizontalTopEnd.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, horizontalBottomEnd.dx, horizontalBottomEnd.dy);
    canvas.drawPath(
      path,
      paint,
    );

    //Draw bottom curve

    var controlPointBottomCurve1 =
        Offset(size.width / 2, topCurvePoint + topCurveGap + 5);
    var controlPointBottomCurve2 =
        Offset(size.width / 2, topCurvePoint + topCurveGap + 15);
    var endPointBottomCurve =
        Offset(size.width / 2, topCurvePoint + topCurveGap + 30);

    var pathBottom = Path();
    pathBottom.moveTo(horizontalBottomStart.dx, horizontalBottomStart.dy);
    pathBottom.cubicTo(
        controlPointBottomCurve1.dx,
        controlPointBottomCurve1.dy,
        controlPointBottomCurve2.dx,
        controlPointBottomCurve2.dy,
        endPointBottomCurve.dx,
        endPointBottomCurve.dy);

    canvas.drawPath(
      pathBottom,
      paint,
    );

    //Draw vertical joint

    Offset verticalJoinEnd =
        Offset(size.width / 2, topCurvePoint + topCurveGap + 50);
    canvas.drawLine(endPointBottomCurve, verticalJoinEnd, paint);

    //Extend vertical line
    var selectedOptionTopHorizontalStart;
    var selectedOptionTopHorizontalEnd;
    var selectedOptionBottomHorizantalStart;
    var selectedOptionBottomHorizantalEnd;

    Offset(size.width / 2, topCurvePoint + topCurveGap + 5);
    Offset(size.width / 2, topCurvePoint + topCurveGap + 5);

    if (currentSelectedIndex == 0) {
      selectedOptionTopHorizontalStart =
          Offset(size.width / 2 + 10, verticalJoinEnd.dy + 5);
      selectedOptionTopHorizontalEnd =
          Offset(size.width / 1.25 + 40, verticalJoinEnd.dy + 5);

      selectedOptionBottomHorizantalStart =
          Offset(size.width / 2 + 10, optionTwoBeginPoint.dy - 5);
      selectedOptionBottomHorizantalEnd =
          Offset(size.width / 1.25 + 40, optionTwoBeginPoint.dy - 5);

      canvas.drawLine(selectedOptionTopHorizontalStart,
          selectedOptionTopHorizontalEnd, paint);
      canvas.drawLine(selectedOptionBottomHorizantalStart,
          selectedOptionBottomHorizantalEnd, paint);

      var topLeftCurvePoint1 =
          Offset(size.width / 2 + 1, verticalJoinEnd.dy + 1);
      var topLeftCurvePoint2 =
          Offset(size.width / 2 + 5, verticalJoinEnd.dy + 4);

      var pathTopLeft = Path();
      pathTopLeft.moveTo(verticalJoinEnd.dx, verticalJoinEnd.dy);
      pathTopLeft.cubicTo(
          topLeftCurvePoint1.dx,
          topLeftCurvePoint1.dy,
          topLeftCurvePoint2.dx,
          topLeftCurvePoint2.dy,
          selectedOptionTopHorizontalStart.dx,
          selectedOptionTopHorizontalStart.dy);
      canvas.drawPath(
        pathTopLeft,
        paint,
      );

      var bottomLeftCurvePoint1 =
          Offset(size.width / 2 + 4, optionTwoBeginPoint.dy - 4);
      var bottomLeftCurvePoint2 =
          Offset(size.width / 2 + 2, optionTwoBeginPoint.dy - 1);

      var pathBottomLeft = Path();
      pathBottomLeft.moveTo(selectedOptionBottomHorizantalStart.dx,
          selectedOptionBottomHorizantalStart.dy);
      pathBottomLeft.cubicTo(
          topLeftCurvePoint1.dx,
          bottomLeftCurvePoint1.dy,
          bottomLeftCurvePoint1.dx,
          bottomLeftCurvePoint2.dy,
          optionTwoBeginPoint.dx,
          optionTwoBeginPoint.dy);
      canvas.drawPath(
        pathBottomLeft,
        paint,
      );
    } else {
      canvas.drawLine(verticalJoinEnd, optionTwoBeginPoint, paint);
    }

    if (currentSelectedIndex == 1) {
      selectedOptionTopHorizontalStart =
          Offset(size.width / 2 + 10, optionTwoBeginPoint.dy + 15);
      selectedOptionTopHorizontalEnd =
          Offset(size.width / 1.25 + 40, optionTwoBeginPoint.dy + 15);

      selectedOptionBottomHorizantalStart =
          Offset(size.width / 2 + 10, optionThreeBeginPoint.dy - 5);
      selectedOptionBottomHorizantalEnd =
          Offset(size.width / 1.25 + 40, optionThreeBeginPoint.dy - 5);

      canvas.drawLine(selectedOptionTopHorizontalStart,
          selectedOptionTopHorizontalEnd, paint);
      canvas.drawLine(selectedOptionBottomHorizantalStart,
          selectedOptionBottomHorizantalEnd, paint);

      var topLeftCurvePoint1 =
          Offset(size.width / 2 + 1, optionTwoBeginPoint.dy + 11);
      var topLeftCurvePoint2 =
          Offset(size.width / 2 + 5, optionTwoBeginPoint.dy + 14);

      var pathTopLeft = Path();
      pathTopLeft.moveTo(optionTwoBeginPoint.dx, optionTwoBeginPoint.dy);
      pathTopLeft.cubicTo(
          topLeftCurvePoint1.dx,
          topLeftCurvePoint1.dy,
          topLeftCurvePoint2.dx,
          topLeftCurvePoint2.dy,
          selectedOptionTopHorizontalStart.dx,
          selectedOptionTopHorizontalStart.dy);
      canvas.drawPath(
        pathTopLeft,
        paint,
      );

      var bottomLeftCurvePoint1 =
          Offset(size.width / 2 + 4, optionThreeBeginPoint.dy - 4);
      var bottomLeftCurvePoint2 =
          Offset(size.width / 2 + 2, optionThreeBeginPoint.dy - 1);

      var pathBottomLeft = Path();
      pathBottomLeft.moveTo(selectedOptionBottomHorizantalStart.dx,
          selectedOptionBottomHorizantalStart.dy);
      pathBottomLeft.cubicTo(
          topLeftCurvePoint1.dx,
          bottomLeftCurvePoint1.dy,
          bottomLeftCurvePoint1.dx,
          bottomLeftCurvePoint2.dy,
          optionThreeBeginPoint.dx,
          optionThreeBeginPoint.dy);
      canvas.drawPath(
        pathBottomLeft,
        paint,
      );
    } else {
      canvas.drawLine(optionTwoBeginPoint, optionThreeBeginPoint, paint);
    }

    if (currentSelectedIndex == 2 ||
        (currentSelectedIndex == 3 && printType == "local_print")) {
      selectedOptionTopHorizontalStart =
          Offset(size.width / 2 + 10, optionThreeBeginPoint.dy + 15);
      selectedOptionTopHorizontalEnd =
          Offset(size.width / 1.25 + 40, optionThreeBeginPoint.dy + 15);

      selectedOptionBottomHorizantalStart =
          Offset(size.width / 2 + 10, optionFourBeginPoint.dy - 5);
      selectedOptionBottomHorizantalEnd =
          Offset(size.width / 1.25 + 40, optionFourBeginPoint.dy - 5);

      canvas.drawLine(selectedOptionTopHorizontalStart,
          selectedOptionTopHorizontalEnd, paint);
      canvas.drawLine(selectedOptionBottomHorizantalStart,
          selectedOptionBottomHorizantalEnd, paint);

      var topLeftCurvePoint1 =
          Offset(size.width / 2 + 1, optionThreeBeginPoint.dy + 11);
      var topLeftCurvePoint2 =
          Offset(size.width / 2 + 5, optionThreeBeginPoint.dy + 14);

      var pathTopLeft = Path();
      pathTopLeft.moveTo(optionThreeBeginPoint.dx, optionThreeBeginPoint.dy);
      pathTopLeft.cubicTo(
          topLeftCurvePoint1.dx,
          topLeftCurvePoint1.dy,
          topLeftCurvePoint2.dx,
          topLeftCurvePoint2.dy,
          selectedOptionTopHorizontalStart.dx,
          selectedOptionTopHorizontalStart.dy);
      canvas.drawPath(
        pathTopLeft,
        paint,
      );

      var bottomLeftCurvePoint1 =
          Offset(size.width / 2 + 4, optionFourBeginPoint.dy - 4);
      var bottomLeftCurvePoint2 =
          Offset(size.width / 2 + 2, optionFourBeginPoint.dy - 1);

      var pathBottomLeft = Path();
      pathBottomLeft.moveTo(selectedOptionBottomHorizantalStart.dx,
          selectedOptionBottomHorizantalStart.dy);
      pathBottomLeft.cubicTo(
          topLeftCurvePoint1.dx,
          bottomLeftCurvePoint1.dy,
          bottomLeftCurvePoint1.dx,
          bottomLeftCurvePoint2.dy,
          optionFourBeginPoint.dx,
          optionFourBeginPoint.dy);
      canvas.drawPath(
        pathBottomLeft,
        paint,
      );
    } else {
      canvas.drawLine(optionThreeBeginPoint, optionFourBeginPoint, paint);
    }
    if (currentSelectedIndex == 3 && printType == "express_print") {
      selectedOptionTopHorizontalStart =
          Offset(size.width / 2 + 10, optionFourBeginPoint.dy + 15);
      selectedOptionTopHorizontalEnd =
          Offset(size.width / 1.25 + 40, optionFourBeginPoint.dy + 15);

      selectedOptionBottomHorizantalStart =
          Offset(size.width / 2 + 10, optionFourEndPoint.dy - 5);
      selectedOptionBottomHorizantalEnd =
          Offset(size.width / 1.25 + 40, optionFourEndPoint.dy - 5);

      canvas.drawLine(selectedOptionTopHorizontalStart,
          selectedOptionTopHorizontalEnd, paint);
      canvas.drawLine(selectedOptionBottomHorizantalStart,
          selectedOptionBottomHorizantalEnd, paint);

      var topLeftCurvePoint1 =
          Offset(size.width / 2 + 1, optionFourBeginPoint.dy + 11);
      var topLeftCurvePoint2 =
          Offset(size.width / 2 + 5, optionFourBeginPoint.dy + 14);

      var pathTopLeft = Path();
      pathTopLeft.moveTo(optionFourBeginPoint.dx, optionFourBeginPoint.dy);
      pathTopLeft.cubicTo(
          topLeftCurvePoint1.dx,
          topLeftCurvePoint1.dy,
          topLeftCurvePoint2.dx,
          topLeftCurvePoint2.dy,
          selectedOptionTopHorizontalStart.dx,
          selectedOptionTopHorizontalStart.dy);
      canvas.drawPath(
        pathTopLeft,
        paint,
      );

      var bottomLeftCurvePoint1 =
          Offset(size.width / 2 + 4, optionFourEndPoint.dy - 4);
      var bottomLeftCurvePoint2 =
          Offset(size.width / 2 + 2, optionFourEndPoint.dy - 1);

      var pathBottomLeft = Path();
      pathBottomLeft.moveTo(selectedOptionBottomHorizantalStart.dx,
          selectedOptionBottomHorizantalStart.dy);
      pathBottomLeft.cubicTo(
          topLeftCurvePoint1.dx,
          bottomLeftCurvePoint1.dy,
          bottomLeftCurvePoint1.dx,
          bottomLeftCurvePoint2.dy,
          optionFourEndPoint.dx,
          optionFourEndPoint.dy);
      canvas.drawPath(
        pathBottomLeft,
        paint,
      );
    } else {
      canvas.drawLine(optionFourBeginPoint, optionFourEndPoint, paint);
    }

    canvas.drawLine(optionFourEndPoint, endingPoint, paint);

    if (currentSelectedIndex < strokeColors.length) {
      var rightCurvePoint1 =
          Offset(size.width / 1.25 + 65, selectedOptionTopHorizontalEnd.dy + 5);
      var rightCurvePoint2 = Offset(
          size.width / 1.25 + 65, selectedOptionBottomHorizantalEnd.dy - 5);

      var pathRight = Path();
      pathRight.moveTo(
          selectedOptionTopHorizontalEnd.dx, selectedOptionTopHorizontalEnd.dy);
      pathRight.cubicTo(
          rightCurvePoint1.dx,
          rightCurvePoint1.dy,
          rightCurvePoint2.dx,
          rightCurvePoint2.dy,
          selectedOptionBottomHorizantalEnd.dx,
          selectedOptionBottomHorizantalEnd.dy);
      canvas.drawPath(
        pathRight,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  bool hitTest(Offset position) {
    // _path - is the same one we built in paint() method;
    return false;
  }
}
