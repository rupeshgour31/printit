import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printit_app/Checkout/checkout_one.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/my_text_field.dart';
import 'package:printit_app/Common/validations_field.dart';
import 'package:printit_app/OrderDetails/order_details.dart';

Widget namePriceShow(context, productMap, model, languageType) {
  return productMap == null
      ? CircularProgressIndicator()
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(12.0, 15.0, 10.0, 15.0),
              height: 160,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: whiteColor,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectTypedName(productMap['order_type'], languageType),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Nunito',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: selectTypedImage(
                          productMap['order_type'],
                        ),
                      ),
                    ],
                  ),
                  heightSizedBox(20.0),
                  Text(
                    productMap['project_name'] ?? '',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            productMap['vendor_charge'] != null ?
            Container(
              height: 150,
              padding: EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width * 0.43,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xff2995cc),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    languageType == 'arabic' ? 'لمجموع الكلي' : 'Total',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ),
                  Text(
                    '${productMap['vendor_charge'].toString() ?? '0'} KD' ?? '',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Nunito',
                      color: whiteColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  // Text(
                  //   'Discount 50%',
                  //   style: TextStyle(
                  //     fontSize: 18.0,
                  //     color: whiteColor,
                  //   ),
                  // ),
                ],
              ),
            ) : Container(),
          ],
        );
}





Widget addMorePrduct(context, productArray, model) {
  return model.pickUpBtn
      ? Container()
      : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add More Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: whiteColor,
                fontFamily: 'Nunito',
              ),
            ),
            heightSizedBox(15.0),
            Container(
              height: 180.0,
              width: 550,
              child: productArray.length == 0
                  ? Center(
                      child: Text(
                        'Product not found !',
                        style: TextStyle(
                          fontSize: 15,
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: productArray.length,
                      itemBuilder: (BuildContext context, int index) {
                        var productQuantity = 0;
                        if (model.productQnt[productArray[index]['id']] != null) {
                          productQuantity = model.productQnt[productArray[index]['id']];
                        }

                        var productPrice = double.parse(productArray[index]['price']) ;
                        if (productQuantity > 0) {
                          productPrice = productPrice * productQuantity;
                        }

                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: InkWell(
                            child: Container(
                              margin: EdgeInsets.only(left: 15.0),
                              width: 320.0,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(15.0)),
                              padding: EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 90,
                                        width: 120.0,
                                        child: Image(
                                          image: NetworkImage(
                                            productArray[index]['image'],
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                        // child:
                                        //     Image.asset('assets/images/flyerimg.png'),
                                      ),
                                      widthSizedBox(12.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            productArray[index]['name'] ?? '',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                          heightSizedBox(4.0),
                                          Text(
                                            productArray[index]['including'] ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black87,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                          heightSizedBox(4.0),
                                          Text(
                                            'PRICE: $productPrice',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: themeColor,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  model.productQnt[productArray[index]['id']] ==
                                              0 ||
                                          model.productQnt[productArray[index]
                                                  ['id']] ==
                                              null
                                      ? Button(
                                          buttonName: 'ADD',
                                          btnWidth: 100,
                                          btnHeight: 30.0,
                                          decoration:
                                              BorderRadius.circular(15.0),
                                          btnColor: Color(0xff2995cc),
                                          color: Color(0xff2995cc),
                                          borderColor: Color(0xff2995cc),
                                          textColor: whiteColor,
                                          onPressed: () {
                                            var singleProductPrice = double.parse(productArray[index]['price']) ;
                                            model.totalProductPrice = model.totalProductPrice + singleProductPrice;
                                            model.qntIncrease(
                                                productArray[index]);
                                          },
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Quantity',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            widthSizedBox(10.0),
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  var singleProductPrice = double.parse(productArray[index]['price']) ;
                                                  model.totalProductPrice = model.totalProductPrice - singleProductPrice;
                                                  model.qntDecrease(
                                                      productArray[index]);
                                                },
                                              ),
                                            ),
                                            widthSizedBox(8.0),
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                color: whiteColor,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  model.productQnt[productArray[
                                                              index]['id']] !=
                                                          null
                                                      ? model.productQnt[
                                                              productArray[
                                                                  index]['id']]
                                                          .toString()
                                                      : '1',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontFamily: 'Nunito',
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            widthSizedBox(8.0),
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  var singleProductPrice = double.parse(productArray[index]['price']) ;
                                                  model.totalProductPrice = model.totalProductPrice + singleProductPrice;
                                                  model.qntIncrease(
                                                      productArray[index]);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
}

Widget promoCodefield(context, model, formKey, applyCoupen) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Enter Promotion Code',
        style: TextStyle(
          color: whiteColor,
          fontFamily: 'Nunito',
          fontSize: 20.0,
        ),
      ),
      // heightSizedBox(15.0),
      Form(
        key: formKey,
        child: AllInputDesign(
          key: Key("Promo Code"),
          cursorColor: Colors.green,
          textStyleColors: Colors.green,
          hintTextStyleColor: Colors.green,
          controller: model.orderDetailsPromoCode,
          outlineInputBorderColor: Colors.green,
          enabledOutlineInputBorderColor: Colors.green,
          focusedBorderColor: Colors.green,
          suffixIcon: GestureDetector(
            onTap: () => applyCoupen(
              model.orderDetailsPromoCode,
              selectPickupDelivery(model),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'apply',
                style: TextStyle(
                  color: Colors.green,
                  fontFamily: 'Nunito',
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          fillColor: Colors.grey.withOpacity(0.2),
          hintText: 'Promo Code',
          validatorFieldValue: 'Promo Code',
          validator: validatePromoCode,
          keyBoardType: TextInputType.name,
        ),
      ),
      // Container(
      //   height: 55.0,
      //   padding: EdgeInsets.only(left: 25.0, right: 25.0),
      //   width: MediaQuery.of(context).size.width,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(40.0),
      //     border: Border.all(
      //       color: Color(0xff00b940),
      //     ),
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Text(
      //         'Delivery',
      //         style: TextStyle(
      //           color: Color(0xff00b940),
      //           fontSize: 20.0,
      //         ),
      //       ),
      //       Text(
      //         'KD 2 Minimum Order',
      //         style: TextStyle(
      //           color: Color(0xff00b940),
      //           fontWeight: FontWeight.w100,
      //           fontSize: 20.0,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    ],
  );
}

Widget botNavCont(
  context,
  model,
  orderData,
  orderId,
  couponData,
  addNewProduct,
) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        padding: EdgeInsets.only(
          right: 15.0,
          left: 15.0,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/img1.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Image.asset(
                orderData['order_type'] != '3' ? 'assets/images/121.png' : 'assets/images/12.png',
              ),
            ),
            Container(
              height: 60,
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 7.0,
                ),
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_outlined,
                    size: 28,
                    color: whiteColor,
                  ),
                  onPressed: () {

                    if (model.deliveryBtn) {
                      if (model.productQnt.isNotEmpty == true) {
                        addNewProduct(model.productQnt);
                      }
                      print("orderData : $orderData");
                      if (orderData["order_type"] == "3") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutOne(
                              orderData: orderData,
                              pickup_delivery: '2',
                              order_id: orderId,
                              couponData: couponData,
                              isFromAdd: false,

                            ),
                          ),
                        );
                      }
                      else {
                        print("Products totalProductPrice ${model.totalProductPrice}");
                        var parsedDouble = double.parse(orderData["vendor_charge"].toString());
                        print("Total cost $parsedDouble");
                        if (parsedDouble + model.totalProductPrice < 1.5) {
                          showPopup(
                            context,
                            Material(
                              color: Colors.transparent,
                              child: Container(
                                height: 200,
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                                      'Minimum order value not met, please add products to proceed further',
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
                        else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutOne(
                                orderData: orderData,
                                pickup_delivery: '2',
                                order_id: orderId,
                                couponData: couponData,
                                isFromAdd: false,
                              ),
                            ),
                          );
                        }
                      }
                    }
                    else if(model.pickUpBtn) {
                      Navigator.pushNamed(
                        context,
                        '/checkoutTwo',
                        arguments: {
                          'orderData': orderData,
                          'pickup_delivery': '1',
                          'order_id': orderId,
                          'couponData': couponData,
                        },
                      );
                    }
                    else {
                      showPopup(
                        context,
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            height: 130,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  'Please select pickup or delivery option',
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
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

selectPickupDelivery(model) {
  if (model.pickUpBtn == false) {
    return 'delivery';
  } else {
    return 'pickup';
  }
}

selectTypedImage(String type) {
  switch (type) {
    case '3':
      return Image.asset(
        'assets/icons/translation.png',
        fit: BoxFit.fill,
        color: Color(0xffd50880),
      );
      break;
    case '2':
      return Image.asset(
        'assets/icons/icon6.png',
        fit: BoxFit.fill,
        color: Color(0xffe6d821),
      );
      break;
    case '1':
      return Image.asset(
        'assets/icons/custom_print copy11.png',
        fit: BoxFit.fill,
        color: Color(0xff2995cc),
      );
      break;
    case '4':
      return Image.asset(
        'assets/icons/paper_icon.png',
        fit: BoxFit.fill,
        color: Color(0xff2995cc),
      );
      break;
    default:
      return Image.asset(
        'assets/icons/paper_icon.png',
        fit: BoxFit.fill,
        color: Color(0xff2995cc),
      );
      break;
  }
}

selectTypedName(String type, languageType) {
  switch (type) {
    case '3':
      return languageType == 'arabic' ? 'ترجمة' : "Translation";
      break;
    case '2':
      return languageType == 'arabic' ? 'طباعة سريعة' : "Quick Print";
      break;
    case '1':
      return languageType == 'arabic' ? 'مخصّصة' : 'Custom Print';
      break;
    case '4':
      return languageType == 'arabic' ? 'ملاحظات' : "Notes";
      break;
    default:
      return languageType == 'arabic' ? 'ملاحظات' : 'Notes';
      break;
  }
}
