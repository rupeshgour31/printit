import 'package:flutter/material.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_widgets.dart';

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
        'Order Id - ${product['order_id'].toString()}' ?? '',
        style: TextStyle(
          fontSize: 15.0,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          color: whiteColor,
        ),
      ),
      heightSizedBox(5.0),
      Text(
        'Order Confirmed',
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

Widget printShop(product) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'PRINT SHOP',
        style: TextStyle(
          fontSize: 20.0,
          color: whiteColor,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
        ),
      ),
      heightSizedBox(8.0),
      Text(
        product['orderData']['shop_name'] ?? '',
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
