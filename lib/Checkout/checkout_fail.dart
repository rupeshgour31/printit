import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSGetOrderDetailsRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Checkout/checkout_model.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CheckoutFail extends StatefulWidget {
  static const routeName = '/checkoutFail';
  @override
  _CheckoutFailState createState() => _CheckoutFailState();
}

class _CheckoutFailState extends State<CheckoutFail> {
  var get_print_type;
  var getOrderPriceDetails;
  var orderId;

  void initState() {
    Future.delayed(Duration.zero, () async {
      await getValuesSF();
    });
    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      setState(
            () {
          // user_id = json.decode(prefs.getString('login_user_id'));
          get_print_type = json.decode(prefs.getString('set_print_type'));
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final Map product = ModalRoute
        .of(context)
        .settings
        .arguments;
    setState(() {
      orderId = product['orderDetails']['order_id'].toString();
    });
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<CheckoutModel>(
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
                            onPressed: () =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomePage.routeName,
                                      (Route<dynamic> route) => false,
                                  arguments: {'print_type': get_print_type},
                                ),
                          ),
                          Text(
                            'Payment Failed',
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
                            onPressed: () =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomePage.routeName,
                                      (Route<dynamic> route) => false,
                                  arguments: {'print_type': get_print_type},
                                ),
                          ),
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
              body: Stack(
                children: [
                  Container(
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
                              heightSizedBox(20.0),

                              FailedView(product['orderDetails']),
                              heightSizedBox(20.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  progressHUD,
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget FailedView(product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Failed',
          style: TextStyle(
            fontSize: 30.0,
            color: Color(0xffe6d821),
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w400,
          ),
        ),
        heightSizedBox(8.0),
        Text(
          'Payment has failed due to some reason, please try again later',
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
}
