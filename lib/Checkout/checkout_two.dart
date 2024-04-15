import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:printit_app/Api/Request/WSGetOrderDetailsRequest.dart';
import 'package:printit_app/Api/Request/WSSaveCompleteOrderWithExistingAddressRequest.dart';
import 'package:printit_app/Api/Request/WSSavePickUpCompleteOrderRequest.dart';
import 'package:printit_app/Api/Request/WSTranslationOrderRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Checkout/checkout_model.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/toast.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'checkoutTwo_widget.dart';

class CheckoutTwo extends StatefulWidget {
  static const routeName = '/checkoutTwo';
  @override
  _CheckoutTwoState createState() => _CheckoutTwoState();
}

class _CheckoutTwoState extends State<CheckoutTwo> {
  var user_id;
  var orderId;
  var orderPriceDetails;
  var languageType;
  var get_print_type;
  bool _isLoading = false;
  var getOrderPriceDetails;
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getValuesSF();
      await getPriceDetails();
    });


    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    var getLang = json.decode(prefs.getString('language_select'));
    languageType = getLang ?? 'english';
    if (status) {
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

  getPriceDetails() async {
    var otpRequest = WSGetOrderDetailsRequest(
      endPoint: APIManagerForm.endpoint,
      orderID: orderId.toString(),
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);

    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        setState(() {
          getOrderPriceDetails = dataResponse['data'];
        });
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void orderPlace(updateOrderDetails) async {
    print('order order ${updateOrderDetails}');
    if (updateOrderDetails['pickup_delivery'] == '1') {
      setState(() {
        _isLoading = true;
      });
      var otpRequest = WSSavePickUpCompleteOrderRequest(
        endPoint: APIManager.endpoint,
        orderId: updateOrderDetails['order_id'].toString() ?? '',
        pickupDelivery: '1',
        printryId: updateOrderDetails['orderData']['id'] ?? '',
        userId: user_id ?? '',
        vendorCharge: updateOrderDetails['orderData']['vendor_charge'].toString() ?? '',
      );
      await APIManager.performRequest(otpRequest, showLog: true);
      try {
        var dataResponse = otpRequest.response;
        if (dataResponse['success'] == true) {
          // Navigator.pushNamed(context, '/checkoutThree', arguments: {
          //   'orderDetails': updateOrderDetails,
          // });
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamed(
            context,
            '/inAppWebview',
            arguments: {
              'orderDetails': updateOrderDetails,
            },
          );

          // Navigator.of(context).pushNamedAndRemoveUntil(
          //   HomePage.routeName,
          //       (Route<dynamic> route) => false,
          //   arguments: {'print_type': 'express_print'},
          // );
        } else {
          var messages = dataResponse['msg'] ?? '';
          setState(() {
            _isLoading = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text('Message'),
                content: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                    widthSizedBox(5.0),
                    Text(
                      messages,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
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
      } catch (e) {
        print('Error: ${e.toString()}');
      }
    } else if (updateOrderDetails['orderData']['order_type'] == '3') {
      setState(() {
        _isLoading = true;
      });
      var otpRequest = WSTranslationCompleteOrderRequest(
        endPoint: APIManager.endpoint,
        orderId: updateOrderDetails['order_id'].toString() ?? '',
        userId: user_id ?? '',
        addressId: updateOrderDetails['address_id'],
      );
      await APIManager.performRequest(otpRequest, showLog: true);
      try {
        var dataResponse = otpRequest.response;
        if (dataResponse['success'] == true) {
          setState(() {
            _isLoading = false;
          });
          showPopup(
            context,
            Material(
              color: Colors.transparent,
              child: Container(
                height: 320,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Order Confirm',
                      style: TextStyle(
                        color: Color(0xff00b940),
                        fontSize: 18.0,
                      ),
                    ),
                    heightSizedBox(25.0),
                    SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: Image.asset(
                        'assets/images/right-11550716422rth6tsvdzw.png',
                      ),
                    ),
                    heightSizedBox(15.0),
                    Text(
                      'Request sent successfully you will get proposals very soon.',
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
                    heightSizedBox(25.0),
                    Button(
                      buttonName: 'Back to home',
                      color: Color(0xff2995cc),
                      btnWidth: 180.0,
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          HomePage.routeName,
                          (Route<dynamic> route) => false,
                          arguments: {'print_type': get_print_type},
                        );
                      },
                      decoration: BorderRadius.circular(15.0),
                    ),
                    heightSizedBox(15.0),
                  ],
                ),
              ),
            ),
          );
        } else {
          var messages = dataResponse['msg'] ?? '';
          setState(() {
            _isLoading = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text('Message'),
                content: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                    widthSizedBox(5.0),
                    Text(
                      messages,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
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
      } catch (e) {
        print('Error: ${e.toString()}');
      }
    } else if (updateOrderDetails['translation_proposal_accept'] == 'yes') {
      setState(() {
        _isLoading = true;
      });
      Navigator.pushNamed(
        context,
        '/inAppWebview',
        arguments: {
          'orderDetails': updateOrderDetails,
        },
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      var otpRequest = WSSaveCompleteOrderWithExistingAddressRequest(
        endPoint: APIManager.endpoint,
        orderId: updateOrderDetails['order_id'].toString() ?? '',
        pickupDelivery: '2',
        printryId: updateOrderDetails['orderData']['id'] ?? '',
        userId: user_id ?? '',
        vendorCharge:
            updateOrderDetails['orderData']['vendor_charge'].toString() ?? '',
        addressId: updateOrderDetails['address_id'],
      );
      await APIManager.performRequest(otpRequest, showLog: true);
      try {
        var dataResponse = otpRequest.response;
        if (dataResponse['success'] == true) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamed(
            context,
            '/inAppWebview',
            arguments: {
              'orderDetails': updateOrderDetails,
            },
          );
        } else {
          var messages = dataResponse['msg'] ?? '';
          setState(() {
            _isLoading = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text('Message'),
                content: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                    widthSizedBox(5.0),
                    Text(
                      messages,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
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
      } catch (e) {
        print('Error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map product = ModalRoute.of(context).settings.arguments;
    print('order pick up 2 ${product}');
    setState(() {
      orderId = product['order_id'].toString();
    });
    return Consumer<CheckoutModel>(
      builder: (context, model, _) {
        return MediaQuery(
          data: mediaText(context),
          child: Scaffold(
            appBar: commonAppbar(
              languageType == 'arabic' ? 'الدفع' : 'Payment',
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
            body: Container(
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
              child: SafeArea(
                child: LoadingOverlay(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 25.0,
                        left: 27.0,
                        right: 27.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          checkOut(true, 2),
                          heightSizedBox(20.0),
                          orderDetails(
                            product,
                            orderId,
                            getOrderPriceDetails,
                            languageType,
                          ),
                          heightSizedBox(20.0),
                          heightSizedBox(20.0),
                          printShop(product),
                          heightSizedBox(20.0),
                          paymentTerms(languageType),
                          heightSizedBox(20.0),
                          nextBtn(
                            orderPlace,
                            product,
                            languageType,
                          ),
                          heightSizedBox(20.0),
                          continueShoppingBtn(
                            context,
                            model,
                            get_print_type,
                            languageType,
                          ),
                          heightSizedBox(20.0),
                          savedOrderBtn(languageType, context, model),
                          heightSizedBox(40.0),
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
            ),
          ),
        );
      },
    );
  }

  Widget paymentTerms(languageType) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageType == 'arabic' ? 'شروط الدفع' : 'PAYMENT TERMS',
          style: TextStyle(
            fontSize: 20.0,
            color: whiteColor,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
          ),
        ),
        heightSizedBox(8.0),
        Text(
          languageType == 'arabic'
              ? 'عند إتمام عملية الدفع، فأنت توافق بشكل تلقائي على شروط وأحكام تطبيق برنت إت'
              : 'By making the payment you automatically Agree on Print it TREMS & CONDITIONS.',
          style: TextStyle(
            fontSize: 15.0,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w400,
            color: whiteColor,
          ),
        ),
      ],
    );
  }

  Widget continueShoppingBtn(
      BuildContext context,
      model,
      get_print_type,
      languageType,
      ) {
    return Button(
      buttonName: languageType == 'arabic' ? 'حفظ ومتابعة' : 'CONTINUE SHOPPING',
      btnWidth: double.infinity,
      decoration: BorderRadius.circular(15.0),
      btnColor:
      model.continueOderBtnPress ? Color(0xff2995cc) : Colors.transparent,
      color: model.continueOderBtnPress ? Color(0xff2995cc) : Colors.transparent,
      borderColor: Color(0xff2995cc),
      textColor: model.continueOderBtnPress ? whiteColor : Color(0xff2995cc),
      onPressed: () {
        model.btnOnTap('continue shopping');
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.routeName,
              (Route<dynamic> route) => false,
          arguments: {'print_type': get_print_type},
        );
      },
    );
  }

  Widget savedOrderBtn(languageType, BuildContext context, model) {
    return Button(
      buttonName: languageType == 'arabic' ? 'حفظ' : 'SAVED ORDER',
      btnWidth: double.infinity,
      decoration: BorderRadius.circular(15.0),
      btnColor: model.savedOrderBtnPress ? Color(0xff2995cc) : Colors.transparent,
      color: model.savedOrderBtnPress ? Color(0xff2995cc) : Colors.transparent,
      borderColor: Color(0xff2995cc),
      textColor: model.savedOrderBtnPress ? whiteColor : Color(0xff2995cc),
      onPressed: () {
        model.btnOnTap('save order');
        Constants.showToast('Order save');
      },
    );
  }
}
