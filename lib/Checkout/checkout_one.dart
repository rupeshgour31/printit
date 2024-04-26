import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:printit_app/Api/Request/WSGetOrderDetailsRequest.dart';
import 'package:printit_app/Api/Request/WSMyAddressListRequest.dart';
import 'package:printit_app/Api/Request/WSTranslationOrderRequest.dart';
import 'package:printit_app/Api/Request/WSUpdateOrdersRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Checkout/checkout_model.dart';
import 'package:printit_app/Checkout/checkout_widgets.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/geoLocation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:printit_app/Home/home_page.dart';
import 'package:printit_app/Api/Request/WSGetOrderDetailsRequest.dart';
import 'package:printit_app/Api/Request/WSSaveCompleteOrderWithExistingAddressRequest.dart';
import 'package:printit_app/Api/Request/WSSavePickUpCompleteOrderRequest.dart';

class CheckoutOne extends StatefulWidget {
  final orderData;
  final pickup_delivery;
  final order_id;
  final couponData;
  final isFromAdd;

  CheckoutOne({
    this.orderData,
    this.pickup_delivery,
    this.order_id,
    this.couponData,
    this.isFromAdd
  });

  // static const routeName = '/checkoutTwo';
  @override
  _CheckoutOneState createState() => _CheckoutOneState();
}

class _CheckoutOneState extends State<CheckoutOne> {
  var user_id;
  var get_print_type;
  var orderPriceDetails;
  var getOrderPriceDetails;
  var languageType;
  var UpdateOrder;
  bool _isLoading = false;
  List myAddresses = [];
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getValuesSF();
      await getMyAddressList();
      await updateOrder('');
      await getLocation();
    });
    super.initState();
    if (!widget.isFromAdd) {
      var modelObj;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        modelObj = Provider.of<CheckoutModel>(context, listen: false);
        print("Bhumit Sandhya ${modelObj.myAddressesToShow}");
        modelObj.myAddressesToShow = null;
        modelObj.myAddressesId = null;
      });
    }

  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    var getLang = json.decode(prefs.getString('language_select')??'');
    languageType = getLang ?? 'english';
    if (status) {
      setState(
        () {
          user_id = json.decode(prefs.getString('login_user_id')??'');
          get_print_type = json.decode(prefs.getString('set_print_type')??'');
        },
      );
    } else {
      this.setState(() {});
    }
  }

  getPriceDetails() async {
    var otpRequest = WSGetOrderDetailsRequest(
      endPoint: APIManagerForm.endpoint,
      orderID: widget.order_id.toString(),
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);

    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        var dataObj = dataResponse['data'];
        // print('Product Array ${dataObj['products']}');

        setState(() {
          getOrderPriceDetails = dataResponse['data'];
        });
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  updateOrder(String addIdGet) async {
    setState(() {
      _isLoading = true;
    });
    var couponCodeGet;
    var getAddressIdForPrice;
    if (widget.couponData != null) {
      couponCodeGet = widget.couponData['coupon_code'];
    }
    ;
    if (addIdGet != '') {
      getAddressIdForPrice = addIdGet;
    }
    ;
    var otpRequest = WSUpdateOrdersRequest(
      endPoint: APIManagerForm.endpoint,
      orderId: widget.order_id.toString(),
      vendorCharge: widget.orderData['vendor_charge'].toString(),
      pickupDelivery: widget.pickup_delivery,
      addId: getAddressIdForPrice,
      couponCode: couponCodeGet,
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('get address list all ${dataResponse['success']}');
      if (dataResponse['success'] == true) {
        await getPriceDetails();
        setState(() {
          _isLoading = false;
          getAddressIdForPrice = '';
        });
      } else {
        var messages = dataResponse['msg'];
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
                    'messages',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              actions: <Widget>[
                // FlatButton(
                //   child: new Text("OK"),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  getMyAddressList() async {
    setState(() {
      _isLoading = true;
    });
    var otpRequest = WSMyAddressListRequest(
      endPoint: APIManager.endpoint,
      userID: user_id.toString(),
    );
    await APIManager.performRequest(otpRequest, showLog: true);

    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        print("myAddresses $myAddresses");
        setState(() {
          // myAddresses = dataResponse['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        // var messages = dataResponse['msg'];
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: new Text('Message'),
        //       content: Row(
        //         children: [
        //           Icon(
        //             Icons.error_outline,
        //             color: Colors.red,
        //           ),
        //           widthSizedBox(5.0),
        //           Text(
        //             messages,
        //             textAlign: TextAlign.center,
        //             maxLines: 2,
        //             // overflow: TextOverflow.ellipsis,
        //           ),
        //         ],
        //       ),
        //       actions: <Widget>[
        //         FlatButton(
        //           child: new Text("OK"),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  Map<String, Marker> _markers = {};
  CameraPosition? _kGooglePlex;
  Completer<GoogleMapController> _controller = Completer();

  getLocation() async {
    setState(
      () {
        _kGooglePlex = CameraPosition(
          target: LatLng(
            double.parse(widget.orderData['latitude']),
            double.parse(widget.orderData['longitude']),
          ),
          zoom: 12,
          bearing: 15.0, // 1
          tilt: 75.0,
        );
        // _markers.clear();
        final marker = Marker(
          markerId: MarkerId('Shop Location'),
          position: LatLng(
            double.parse(widget.orderData['latitude']),
            double.parse(widget.orderData['longitude']),
          ),
          infoWindow: InfoWindow(),
        );
        _markers['Shop Location'] = marker;
      },
    );
  }

  showMap() {
    print('google map key get ${_kGooglePlex}');
    return GoogleMap(
      markers: _markers.values.toSet(),
      myLocationEnabled: false,
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      initialCameraPosition: _kGooglePlex!,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final Map product = ModalRoute.of(context).settings.arguments;
    print('order pick up 1 ${widget.orderData}');
    print('apply code pick ${widget.couponData}');
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
                child: SafeArea(
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
                            widget.orderData,
                            widget.couponData,
                            orderPriceDetails,
                            getOrderPriceDetails,
                            languageType,
                          ),
                          heightSizedBox(25.0),
                          expectedDeliveryTime(),
                          heightSizedBox(20.0),
                          deliveryAddress(
                            context,
                            model,
                            myAddresses,
                            user_id,
                            updateOrder,
                            getMyAddressList,
                            widget.orderData,
                            widget.couponData,
                            widget.order_id,
                            languageType,
                          ),
                          printShop(widget.orderData),
                          _kGooglePlex != null
                              ? Container(
                                  margin: EdgeInsets.only(top: 15.0),
                                  height: 180,
                                  width: double.infinity,
                                  child: showMap(),
                                )
                              : Container(),
                          heightSizedBox(25.0),
                          paymentTerms(languageType),
                          heightSizedBox(30.0),
                          checkoutBtn(
                            context,
                            model,
                            widget.orderData,
                            widget.order_id,
                            languageType,
                            widget.orderData,
                              get_print_type,
                            user_id,
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

  Widget checkoutBtn(
      BuildContext context, model, product, order_id, languageType, orderData, get_print_type, user_id) {
    print("Bhumit Mehta checkoutBtn ${orderData["order_type"]}");
    return Button(
      buttonName: languageType == 'arabic' ? 'الدفع' : 'CHECKOUT',
      btnWidth: double.infinity,
      decoration: BorderRadius.circular(15.0),
      btnColor: model.checkoutBtnPress ? Color(0xff2995cc) : Colors.transparent,
      color: model.checkoutBtnPress ? Color(0xff2995cc) : Colors.transparent,
      borderColor: Color(0xff2995cc),
      textColor: model.checkoutBtnPress ? whiteColor : Color(0xff2995cc),
      onPressed: () => {
        perfromCheckoutAction(context, model, product, order_id, languageType, orderData, get_print_type, user_id)
      },
    );
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
        vendorCharge: updateOrderDetails['orderData']['price'] ?? '',
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
                      'messages',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                actions: <Widget>[
                  // FlatButton(
                  //   child: new Text("OK"),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Error: ${e.toString()}');
      }
    } else if (updateOrderDetails['order_type'] == '3') {
      setState(() {
        _isLoading = true;
      });
      var otpRequest = WSTranslationCompleteOrderRequest(
        endPoint: APIManager.endpoint,
        orderId: updateOrderDetails['order_id'].toString() ?? '',
        userId: user_id ?? '',
        addressId: updateOrderDetails['address_id'].toString(),
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
                      'messages',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                actions: <Widget>[
                  // FlatButton(
                  //   child: new Text("OK"),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
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
        printryId: updateOrderDetails['id'] ?? '',
        userId: user_id ?? '',
        vendorCharge:
        updateOrderDetails['vendor_charge'].toString() ?? '',
        addressId: updateOrderDetails['address_id'].toString(),
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
                      'messages',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                actions: <Widget>[
                  // FlatButton(
                  //   child: new Text("OK"),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
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

  void perfromCheckoutAction(BuildContext context, model, product, order_id, languageType, orderData, get_print_type, user_id) async {

      print("Priyanka hingu perfromCheckoutAction");
      product["pickup_delivery"] = "2";
      product["order_id"] = order_id;
      product["address_id"] = model.myAddressesId;
      product["orderData"] = product;

      model.btnOnTap('checkout');
      model.myAddressesId != null
          ? orderPlace(product)
          : showDialog(
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
                  'please select address',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  // overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            actions: <Widget>[
              // FlatButton(
              //   child: new Text("OK"),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
          );
        },
      );
    }

}
