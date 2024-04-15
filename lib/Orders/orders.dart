import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:printit_app/Api/Request/WSDeleteSavedItemsRequest.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/toast.dart';
import 'package:printit_app/Orders/orders_widgets.dart';
import 'package:printit_app/Api/Request/WSGetOrderRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List historyOrders = [];
  List savedOrdersList = [];
  var user_id;
  var get_print_type;
  var languageType;
  var isSelected = false;
  // var mycolor = Colors.red;
  @override
  void initState() {
    super.initState();
    getValuesSF();
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
    getOrders();
  }

  getOrders() async {
    setState(() {
      _isLoading = true;
    });
    var orderReq = WSGetOrderRequest(
      endPoint: APIManager.endpoint,
      userID: user_id,
    );
    await APIManager.performRequest(orderReq, showLog: true);

    try {
      var dataResponse = orderReq.response;
      setState(() {
        savedOrdersList = dataResponse["saved_orders"];
        historyOrders = dataResponse["completed_orders"];
        _isLoading = false;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  bool _isLoading = false;
  List _selectedIndexList = [];
  bool _selectionMode = false;
  void toggleSelection(bool enable, index) {
    // _selectionMode = enable;
    setState(() {
      if (isSelected) {
        // mycolor = Colors.white;
        isSelected = false;
      } else {
        // mycolor = Colors.grey[300];
        isSelected = true;
      }
    });
    _selectedIndexList.add(index);
    if (index == 1) {
      _selectedIndexList.clear();
    }
  }

  selectUnselect(index) {
    setState(() {
      if (_selectedIndexList.contains(index)) {
        _selectedIndexList.remove(index);
      } else {
        _selectedIndexList.add(index);
      }
    });
  }

  void deleteItems() async {
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
                'Alert',
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
                'Are you sure you want to delete the order(s)',
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
                buttonName: 'DELETE',
                color: Color(0xff2995cc),
                decoration: BorderRadius.circular(20.0),
                onPressed: () => {
                  this.deleteExecute(),
                  Navigator.pop(context)
                },
              )
            ],
          ),
        ),
      ),
    );


  }

  void deleteExecute() async {
    setState(() {
      _isLoading = true;
    });
    var otpRequest = WSDeleteSavedItemsRequest(
      endPoint: APIManager.endpoint,
      order_id: _selectedIndexList,
      user_id: user_id,
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        Constants.showToast('Item deleted successfully');
        getOrders();
        setState(() {
          _isLoading = false;
        });

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString(
        //   'login_user_id',
        //   json.encode(
        //     dataResponse['user_id'],
        //   ),
        // );
        // prefs?.setBool("isLoggedIn", true);

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
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 50.0),
                      height: 50,
                      child: Text(
                        messages,
                        // textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Nunito',
                        ),
                        maxLines: 2,
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
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        languageType == 'arabic' ? 'الطلبات' : 'ORDERS',
        context,
        IconButton(
          icon: Image.asset(
            'assets/icons/trash_icon.png',
            color: whiteColor,
          ),
          onPressed: () => deleteItems(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: LoadingOverlay(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 15.0,
            right: 5.0,
            bottom: 10.0,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/img1.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                savedOrderText(),
                heightSizedBox(20.0),
                savedOrders(
                  context,
                  savedOrdersList,
                  toggleSelection,
                  isSelected,
                  _selectedIndexList,
                  selectUnselect,
                ),
                heightSizedBox(20.0),
                orderHistoryText(),
                heightSizedBox(20.0),
                orderHistoryItems(historyOrders),
                heightSizedBox(20.0),
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
    );
  }
}
