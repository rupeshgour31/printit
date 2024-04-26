import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:printit_app/Api/Request/WSOrderPrinteryListRequest.dart';
import 'package:printit_app/Api/Request/WSUpdateOrdersRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Dashboard/dashboard.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:printit_app/OrderDetails/order_details.dart';
import 'package:printit_app/SelectPrintShop/select_print_shop_model.dart';
import 'package:printit_app/SelectPrintShop/select_print_shop_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectPrintShop extends StatefulWidget {
  final orderId;
  final comeFrom;
  SelectPrintShop({
    this.orderId,
    this.comeFrom,
  });
  @override
  _SelectPrintShopState createState() => _SelectPrintShopState();
}

class _SelectPrintShopState extends State<SelectPrintShop> {
  var get_print_type;

  List printiesArray = [];
  var msg;
  var projectName;
  var orderType;
  bool _isLoading = false;
  void initState() {
    order_printery_list();
    getValuesSF();
    super.initState();
    var modelObj;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      modelObj = Provider.of<SelectPrintShopModel>(context, listen: false);
      modelObj.productSelctTocheckout = null;
    });
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      setState(
        () {
          // user_id = json.decode(prefs.getString('login_user_id'));
          get_print_type = json.decode(prefs.getString('set_print_type')??'');
        },
      );
      print('@ GHG ${get_print_type}');
    }
  }

  void order_printery_list() async {
    setState(() {
      _isLoading = true;
    });
    var otpRequest = WSOrderPrinteryListRequest(
      endPoint: APIManager.endpoint,
      order_id: widget.orderId.toString(),
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        if (dataResponse['msg'] == null) {
          setState(() {
            // printiesArray = dataResponse['data'];
            projectName = dataResponse['project_name'];
            orderType = dataResponse['order_type'];
            _isLoading = false;
          });
        } else {
          setState(() {
            msg = dataResponse['msg'];
            _isLoading = false;
          });
        }
      } else {
        var messages = dataResponse['msg'];
        setState(() {
          msg = dataResponse['msg'];
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

  updateOrder(model) async {
    setState(() {
      _isLoading = true;
    });
    var otpRequest = WSUpdateOrdersRequest(
      endPoint: APIManagerForm.endpoint,
      orderId: widget.orderId.toString(),
      vendorCharge: model.productSelctTocheckout['vendor_charge'].toString(),
      printryId: model.productSelctTocheckout['id'].toString(),
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('sfjdsklfjdslik${dataResponse}');
      if (dataResponse['success'] == true) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetails(
              orderDetail: model.productSelctTocheckout,
              order_id: widget.orderId,
            ),
          ),
        );
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<SelectPrintShopModel>(
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
                                widget.comeFrom == 'save_order'
                                    ? Navigator.pop(context)
                                    : Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                        HomePage.routeName,
                                        (Route<dynamic> route) => false,
                                        arguments: {'print_type': get_print_type},
                                      );
                              }),
                          Text(
                            'Printies Name',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                              color: whiteColor,
                            ),
                          ),
                          Text('')
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                  ),
                ),
              ),
              // commonAppbar(
              //   'Printies Name',
              //   context,
              //   Text(
              //     '----------',
              //     style: TextStyle(
              //       color: Colors.transparent,
              //     ),
              //   ),
              // ),
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          msg != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 300.0),
                                  child: Center(
                                    child: Text(
                                      'Printeries not available.',
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                )
                              : printiesListView(
                                  printiesArray,
                                  context,
                                  model,
                                  projectName,
                                  orderType,
                                ),
                        ],
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
              bottomNavigationBar: bottomNavContainer(
                msg,
                context,
                model,
                widget.orderId,
                projectName,
                updateOrder,
              ),
            ),
          );
        },
      ),
    );
  }
}
