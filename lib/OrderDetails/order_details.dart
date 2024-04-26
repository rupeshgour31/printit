import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:printit_app/Api/Request/WSAddNewProductRequest.dart';
import 'package:printit_app/Api/Request/WSGetOrderDetailsRequest.dart';
import 'package:printit_app/Api/Request/WSGetProductListRequest.dart';
import 'package:printit_app/Api/Request/WSPromoCodeApplyRequest.dart';
import 'package:printit_app/Api/Request/WSUpdateOrdersRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/toast.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:printit_app/OrderDetails/order_details_model.dart';
import 'package:printit_app/OrderDetails/order_details_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _OrderDetailsState extends State<OrderDetails> {
  List product = [];
  @override
  var user_id;
  var get_print_type;
  var languageType;
  bool _isLoading = false;
  var modelObj;
  var couponData;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      modelObj = Provider.of<OrderDetailsModel>(context, listen: false);
      modelObj.totalProductPrice = 0.0;
      modelObj.productQnt = {};
      modelObj.pickUpBtn = false;
      modelObj.deliveryBtn = false;

    });
    couponData = null;

    getValuesSF();
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
      print('@ GHG ${get_print_type}');
      if (get_print_type == 'express_print') {
        modelObj.btnOnTap('delivery');
         updateOrder('2');

    }


    } else {
      this.setState(() {});
    }
    getProductList();
  }

  void getProductList() async {
    setState(() {
      _isLoading = true;
    });
    var orderReq = WSGetProductListRequest(
      endPoint: APIManager.endpoint,
      // orderID: widget.order_id,
    );
    await APIManager.performRequest(orderReq, showLog: true);

    try {
      Map dataResponse = orderReq.response;
      if (dataResponse['success'] == true) {
        setState(() {
          product = dataResponse["data"];
          _isLoading = false;
        });
      } else {
        var messages = dataResponse['data'];
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

  bool _saving = false;
  bool _loading = false;
  applyCoupen(getCode, deliveryType) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      var otpRequest = WSSApplyPromoCodeRequest(
        endPoint: APIManager.endpoint,
        couponCode: getCode.text,
        orderId: widget.order_id.toString(),
        vendorCharge: widget.orderDetail['vendor_charge'].toString(),
        pickupDelivery: deliveryType,
        serviceType: get_print_type,
      );
      await APIManager.performRequest(otpRequest, showLog: true);
      try {
        var dataResponse = otpRequest.response;
        if (dataResponse['success'] == true) {
          Constants.showToast('Coupon Applied');
          print('apply code ${dataResponse}');

          setState(() {
            couponData = dataResponse;
            _isLoading = false;
            getCode.clear();
          });
        } else {
          var messages = dataResponse['msg'];
          setState(() {
            _isLoading = false;
            getCode.clear();
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

  addNewProduct(productMap) async {
    setState(() {
      _isLoading = true;
    });
    var ids = productMap.keys.toString().replaceAll('(', '');
    var finalIdGet = ids.replaceAll(')', '');
    var values = productMap.values.toString().replaceAll('(', '');
    var finalValueGet = values.replaceAll(')', '');
    var otpRequest = WSAddNewProductRequest(
      endPoint: APIManager.endpoint,
      orderId: widget.order_id.toString(),
      productId: finalIdGet,
      quantity: finalValueGet,
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        setState(() {
          _isLoading = false;
        });
        // Constants.showToast('Coupon Applied');
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

  var bodyProgress = new Container(
    child: Container(
      margin: EdgeInsets.only(top: 300.0),
      decoration: new BoxDecoration(
          color: Colors.blue[200],
          borderRadius: new BorderRadius.circular(10.0)),
      width: 300.0,
      height: 80.0,
      alignment: Alignment.center,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(
            child: new SizedBox(
              height: 50.0,
              width: 50.0,
              child: new CircularProgressIndicator(
                value: null,
                strokeWidth: 7.0,
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: new Center(
              child: new Text(
                "loading.. wait...",
                style: new TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  final formKey = GlobalKey<FormState>();
  // _loading
  // ? bodyProgress
  //     :
  @override
  Widget build(BuildContext context) {
    print('order done ${widget.orderDetail}');
    // final Map product = ModalRoute.of(context).settings.arguments;
    return Consumer<OrderDetailsModel>(
      builder: (context, model, _) {
        return MediaQuery(
          data: mediaText(context),
          child: Scaffold(
            appBar: commonAppbar(
              languageType == 'arabic'
                  ? 'تفاصيل الطلب الخاص بك'
                  : 'Order Details',
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
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/img1.png',
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 1.0,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            widget.orderDetail == null
                                ? CircularProgressIndicator()
                                : namePriceShow(
                                    context,
                                    widget.orderDetail,
                                    model,
                                    languageType,
                                  ),
                            heightSizedBox(30.0),
                            get_print_type == 'express_print' ||
                                    widget.orderDetail['order_type'] == '3'
                                ? Container()
                                : pickUpBtn(context, model),
                            deliveryBtn(
                              context,
                              model,
                              widget.orderDetail,
                              languageType,
                            ),
                            heightSizedBox(20.0),
                            (widget.orderDetail['order_type'] == '3') ? Container() : addMorePrduct(context, product, model),

                            heightSizedBox(30.0),
                            widget.orderDetail['order_type'] != '3'
                                ? promoCodefield(
                                    context,
                                    model,
                                    formKey,
                                    applyCoupen,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // progressHUD,
                ],
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
            bottomNavigationBar: botNavCont(
              context,
              model,
              widget.orderDetail,
              widget.order_id,
              couponData,
              addNewProduct,
            ),
          ),
        );
      },
    );
  }
  Widget deliveryBtn(
      context,
      model,
      productMap,
      languageType,
      ) {
    return GestureDetector(
      onTap: () => { 
        model.btnOnTap('delivery'),
        updateOrder('2')
      },
      child: Container(
        height: 75.0,
        padding: EdgeInsets.only(left: 25.0, right: 25.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: model.deliveryBtn ? Color(0xff2995cc) : Colors.transparent,
          borderRadius: BorderRadius.circular(40.0),
          border: Border.all(
            color: Color(0xff2995cc),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Delivery',
              style: TextStyle(
                color: model.deliveryBtn ? whiteColor : Colors.grey,
                fontFamily: 'Nunito',
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'KD 1.5 Minimum Order' ?? '',
              style: TextStyle(
                color: Color.fromRGBO(244, 244, 244, 1),
                fontFamily: 'Nunito',
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pickUpBtn(context, model) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => { 
            model.btnOnTap('pickup'),
            updateOrder('1')
          },
          child: Container(
            height: 75.0,
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: model.pickUpBtn ? Color(0xff2995cc) : Colors.transparent,
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(
                color: Color(0xff2995cc),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 0, top: 20),
              child: Text(
                'Pick Up',
                style: TextStyle(
                  color: whiteColor,
                  fontFamily: 'Nunito',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        heightSizedBox(20.0),
      ],
    );
  }

  updateOrder(pickupTypeString) async {
    setState(() {
      _isLoading = true;
    });
    var otpRequest = WSUpdateOrdersRequest(
      endPoint: APIManagerForm.endpoint,
      orderId: widget.order_id.toString(),
      vendorCharge: widget.orderDetail['vendor_charge'].toString(),
      pickupDelivery: pickupTypeString,
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('sfjdsklfjdslik${dataResponse}');
      if (dataResponse['success'] == true) {
        setState(() {
          _isLoading = false;
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
}

class OrderDetails extends StatefulWidget {
  final orderDetail;
  final order_id;
  OrderDetails({
    this.orderDetail,
    this.order_id,
  });
  // static const routeName = '/orderDetails';

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}
