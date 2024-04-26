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


class OrderStatus extends StatefulWidget {
  static const routeName = '/checkoutThree';
  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  var get_print_type;
  var getOrderPriceDetails;
  var orderId;
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
    if (status) {
      setState(
        () {
          // user_id = json.decode(prefs.getString('login_user_id'));
          get_print_type = json.decode(prefs.getString('set_print_type')??'');
        },
      );
    }
  }

  getPriceDetails() async {
    print('@ GHG ${get_print_type}');
    // progressHUD.state.show();
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
        // progressHUD.state.dismiss();
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    // progressHUD.state.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final  product = ModalRoute.of(context)!.settings.arguments;
    setState(() {
      orderId = '';//product['orderID'].toString();
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
                            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                              HomePage.routeName,
                                  (Route<dynamic> route) => false,
                              arguments: {'print_type': get_print_type},
                            ),
                          ),
                          Text(
                            'Order Status',
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
                            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
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
                              checkOut(true, 3),
                              heightSizedBox(20.0),
                              orderDetails(
                                product,
                                getOrderPriceDetails,
                              ),
                              heightSizedBox(20.0),
                              heightSizedBox(20.0),
                              heightSizedBox(20.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // progressHUD,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget orderDetails(product, getOrderPriceDetails) {
    List productsArray = getOrderPriceDetails != null ? getOrderPriceDetails['products'] : [];
    List<Widget> productsChildren() {
      return new List<Widget>.generate( productsArray != null ? productsArray.length : 0, (int index) {
        return   Padding(
          padding: const EdgeInsets.only(top:5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productsArray[index]['name'] + '     x ' + productsArray[index]['qty'] + ' (qty)',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w400,
                  color: whiteColor,
                ),
              ),
              Text(
                '${productsArray[index]['total'] ?? '0'} KD' ??
                    '',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w400,
                  color: whiteColor,
                ),
              ),
            ],
          ),
        );
      });
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Id - ${product['orderID'].toString()}' ?? '',
          style: TextStyle(
            fontSize: 15.0,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w400,
            color: whiteColor,
          ),
        ),
        heightSizedBox(5.0),
        Text(
          product["OrderStatus"],
          style: TextStyle(
            fontSize: 30.0,
            color: Color(0xffe6d821),
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w400,
          ),
        ),
        heightSizedBox(18.0),
        Text(
          'Thank You For Trusting \nPrint It',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Nunito',
            color: whiteColor,
          ),
        ),
        heightSizedBox(18.0),
        getOrderPriceDetails == null
            ? Center(
          child: Text(
            'Prices Loading ...',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Nunito',
              color: whiteColor,
            ),
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PAYMENT DETAILS',
              style: TextStyle(
                fontSize: 20.0,
                color: whiteColor,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
              ),
            ),
            heightSizedBox(8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: whiteColor,
                  ),
                ),
                Text(
                  '${getOrderPriceDetails['vendor_charge'].toString() ?? '0'} kd',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: whiteColor,
                  ),
                ),
              ],
            ),
            heightSizedBox(5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Fees',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: whiteColor,
                  ),
                ),
                Text(
                  '${getOrderPriceDetails['service_fee'] ?? '0'} kd',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: whiteColor,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                if (getOrderPriceDetails['delivery_charge'] != '0') ...[
                  heightSizedBox(5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Fees',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400,
                          color: whiteColor,
                        ),
                      ),
                      Text(
                        '${getOrderPriceDetails['delivery_charge'] ?? '0'} kd',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                  heightSizedBox(5.0)
                ],
              ],
            ),
            Column(
              children: [
                if (getOrderPriceDetails['applied_coupon_amt'] != '0') ...[
                  heightSizedBox(5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Applied Coupon',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400,
                          color: whiteColor,
                        ),
                      ),
                      Text(
                        '${getOrderPriceDetails['applied_coupon_amt'] ?? '0'} KD' ??
                            '',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            Column(
                children: productsChildren()
            ),
            heightSizedBox(8.0),
            dividerCommon(
              height: 1.0,
              thickness: 1.0,
              color: whiteColor,
            ),
            heightSizedBox(5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: whiteColor,
                  ),
                ),
                Text(
                  '${getOrderPriceDetails['order_total'] ?? '0'} kd',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: whiteColor,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
