import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart';
import 'package:printit_app/Api/Request/WSTranslationOrderRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/my_text_field.dart';
import 'package:printit_app/Common/toast.dart';
import 'package:printit_app/Common/validations_field.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyBe0j7QlQQeRTlMdzJIdfPCvhRLq9Ks3js";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

Widget orderDetails(
  orderData,
  couponData,
  orderPriceDetails,
  getOrderPriceDetails,
  languageType,
) {
  print("orderData checkout 1 : $orderData");

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
  return (orderData["order_type"] != '3')
      ? getOrderPriceDetails == null
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
                  languageType == 'arabic'
                      ? 'تفاصيل الطلب الخاص بك'
                      : 'ORDER DETAILS',
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
                      selectTypedName(orderData['order_type'], languageType) ??
                          '',
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
                      languageType == 'arabic' ? 'رسوم الخدمة' : 'Service Fees',
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
                      languageType == 'arabic' ? 'لمجموع الكلي' : 'Total',
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
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     if (getOrderPriceDetails['products'].length != 0) ...[
                //       heightSizedBox(15.0),
                //       Text(
                //         'Products ',
                //         style: TextStyle(
                //           fontSize: 20.0,
                //           fontFamily: 'Nunito',
                //           fontWeight: FontWeight.bold,
                //           color: whiteColor,
                //         ),
                //       ),
                //       heightSizedBox(5.0),
                //       ListView.builder(
                //         scrollDirection: Axis.vertical,
                //         shrinkWrap: true,
                //         itemCount: getOrderPriceDetails['products'].length,
                //         itemBuilder: (BuildContext context, int index) {
                //           return Column(
                //             children: [
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   widthSizedBox(10.0),
                //                   Text(
                //                     getOrderPriceDetails['products'][index]['name'],
                //                     style: TextStyle(
                //                       fontSize: 18,
                //                       color: whiteColor,
                //                       fontFamily: 'Nunito',
                //                     ),
                //                   ),
                //                   Text(
                //                     getOrderPriceDetails['products'][index]['qty'],
                //                     style: TextStyle(
                //                       fontSize: 18,
                //                       color: whiteColor,
                //                       fontFamily: 'Nunito',
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           );
                //         },
                //       ),
                //     ],
                //   ],
                // ),
              ],
            )
      : Container();
}

Widget expectedDeliveryTime() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Expected delivery time ',
        style: TextStyle(
          fontSize: 25.0,
          color: whiteColor,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
        ),
      ),
      heightSizedBox(8.0),
      Text(
        '3 Working days',
        style: TextStyle(
          fontSize: 22.0,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          color: Colors.lightBlue,
        ),
      ),
    ],
  );
}

final formKey = GlobalKey<FormState>();
String dropdownValue = 'home';

Widget deliveryAddress(
  context,
  model,
  myAddressesList,
  user_id,
  updateOrder,
  getMyAddressList,
  orderData,
  coupenData,
  orderId,
  languageType,
) {

  return StatefulBuilder(
    builder: (context, setState) {

      return GestureDetector(
        onTap: () {
          model.saveMyAdd(myAddressesList);
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.55,
                //set this as you want
                maxChildSize: 0.55,
                //set this as you want
                minChildSize: 0.55,
                //set this as you want
                expand: true,
                builder: (context, scrollController) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      List addressArray = myAddressesList != null ? myAddressesList : [];
                      List<Widget> addressWidgetsList() {
                        return new List<Widget>.generate( addressArray != null ? addressArray.length : 0, (int index) {
                          print("Address index index $index");
                          return   Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: GestureDetector(
                              onTap: () {
                                model.selectAddTypes(index);
                                setState(
                                      () {

                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                width: double.infinity,
                                height: 45.0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(40),
                                  color: (model.myAddressesId != null && model.mySavedAddresses[index]
                                  ['id'] == model.myAddressesId)
                                      ? Color(0xff2995cc)
                                      : whiteColor,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      model.mySavedAddresses[index]
                                      ['address_type'] ??
                                          '',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color:  (model.myAddressesId != null && model.mySavedAddresses[index]
                                        ['id'] == model.myAddressesId)
                                            ? whiteColor
                                            : Colors.black,
                                        fontFamily: 'Nunito',
                                        fontWeight:
                                        FontWeight.w400,
                                      ),
                                    ),
                                    widthSizedBox(10.0),
                                    Flexible(
                                      child: Text(
                                        model.mySavedAddresses[index]
                                        ['address'] ??
                                            '',
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: new TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'Nunito',
                                          color:
                                          (model.myAddressesId != null && model.mySavedAddresses[index]
                                          ['id'] == model.myAddressesId)
                                              ? whiteColor
                                              : Colors.black,
                                          fontWeight:
                                          FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      }
                      return Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'SELECT DELIVERY ADDRESS',
                                  style: TextStyle(
                                    inherit: true,
                                    color: Colors.grey,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.0,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 25.0,
                                    color: Colors.black,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.28,
                              padding: EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              child: SingleChildScrollView(
                                child:   Column(
                                    children: addressWidgetsList()
                                ),
                              ),
                            ),
                            heightSizedBox(10.0),
                            Button(
                              btnHeight: 45.0,
                              btnWidth: double.infinity,
                              color: Color(0xff001b29),
                              decoration: BorderRadius.circular(40.0),
                              btnColor: Color(0xff001b29),
                              buttonName: 'NEW ADDRESS',
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return DraggableScrollableSheet(
                                          initialChildSize: 0.82,
                                          //set this as you want
                                          maxChildSize: 0.82,
                                          //set this as you want
                                          minChildSize: 0.82,
                                          //set this as you want
                                          expand: true,
                                          builder: (context, scrollController) {
                                            return Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.all(20.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(30),
                                                  topLeft: Radius.circular(30),
                                                ),
                                                color: whiteColor,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Form(
                                                  key: formKey,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      addAddressText(context),
                                                      addressNameTextField(
                                                          model),
                                                      areaTextField(
                                                        context,
                                                        model,
                                                        user_id,
                                                        orderData,
                                                        coupenData,
                                                        orderId,
                                                      ),
                                                      heightSizedBox(15.0),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0,
                                                          top: 5.0,
                                                          bottom: 5.0,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          color:
                                                              Colors.grey[200],
                                                        ),
                                                        width: double.infinity,
                                                        height: 50,
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          value: dropdownValue,
                                                          icon: Icon(Icons
                                                              .arrow_downward),
                                                          iconSize: 24,
                                                          elevation: 16,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .deepPurple),
                                                          underline: Container(
                                                            height: 2,
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              dropdownValue =
                                                                  newValue!;
                                                              model.addType =
                                                                  newValue;
                                                            });
                                                          },
                                                          items: <String>[
                                                            'home',
                                                            'office',
                                                            'apartment'
                                                          ].map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(
                                                                value,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      15.0,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                      blockTextField(model),
                                                      streetTextField(model),
                                                      avenueTextField(model),
                                                      addMobTextField(model),
                                                      dropdownValue == 'home'
                                                          ? homeTextField(model)
                                                          : Text(''),
                                                      dropdownValue ==
                                                                  'apartment' ||
                                                              dropdownValue ==
                                                                  'office'
                                                          ? buildingTextField(
                                                              model)
                                                          : Text(''),
                                                      dropdownValue == 'office'
                                                          ? officeTextField(
                                                              model)
                                                          : Text(''),
                                                      dropdownValue ==
                                                                  'apartment' ||
                                                              dropdownValue ==
                                                                  'office'
                                                          ? floorTextField(
                                                              model)
                                                          : Text(''),
                                                      dropdownValue ==
                                                              'apartment'
                                                          ? apartmentNoTextField(
                                                              model)
                                                          : Text(''),
                                                      // extraInstruction(model),
                                                      heightSizedBox(20.0),
                                                      saveAddBtn(
                                                        context,
                                                        model,
                                                        user_id,
                                                        orderData,
                                                        coupenData,
                                                        orderId,
                                                          updateOrder
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            heightSizedBox(10.0),
                            GestureDetector(
                              onTap: () {
                                updateOrder(model.myAddressesId);
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff29adcc),
                                      Color(0xff2995cc),
                                    ],
                                    end: Alignment.bottomRight,
                                    begin: Alignment.centerLeft,
                                    tileMode: TileMode.repeated,
                                  ),
                                ),
                                child: Text(
                                  'DONE',
                                  style: TextStyle(
                                    inherit: true,
                                    color: whiteColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
          setState(() {});
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageType == 'arabic' ? 'العنوان' : 'ADDRESS',
              style: TextStyle(
                fontSize: 24.0,
                color: whiteColor,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
              ),
            ),
            heightSizedBox(8.0),
            myAddressesList.length == 0
                ? Text('')
                : Text(
                    model.myAddressesToShow == null ||
                            model.myAddressesToShow.length == 0
                        ? 'Click to  select address'
                        : model.myAddressesToShow,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ],
        ),
      );
    },
  );
}

Widget printShop(orderData) {
  return orderData['shop_name'] != null
      ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightSizedBox(25.0),
            Text(
              'PRINT SHOP',
              style: TextStyle(
                fontSize: 20.0,
                color: whiteColor,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
              ),
            ),
            heightSizedBox(8.0),
            Text(
              orderData['shop_name'] ?? '',
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        )
      : Text('');
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

Widget addAddressText(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'ADD NEW ADDRESS',
      ),
      IconButton(
        icon: Icon(
          Icons.close,
          size: 25.0,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      )
    ],
  );
}

Widget areaTextField(
  BuildContext context,
  model,
  user_id,
  orderData,
  coupenData,
  orderId,
) {
  Mode _mode = Mode.overlay;

  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Button(
          buttonName: (model.areaName != '') ? model.areaName : 'Select Area *',
          btnWidth: double.infinity,
          btnHeight: 50,
          decoration: BorderRadius.circular(15.0),
          textColor: Colors.grey,
          color: Color.fromRGBO(235, 235, 235, 1),
          onPressed: () async {
            // show input autocomplete with selected mode
            // then get the Prediction selected
            // Prediction p = await PlacesAutocomplete.show(
            //   context: context,
            //   apiKey: kGoogleApiKey,
            //   onError: onError,
            //   mode: _mode,
            //   language: "en",
            //   components: [Component(Component.country, "kw")],
            // );
            // if (p != null) {
            //   print("PlaceID ${p.placeId}");
            //   PlacesDetailsResponse detail =
            //       await _places.getDetailsByPlaceId(p.placeId);
            //   print("detail ${detail.errorMessage}");
            //   var placeId = p.placeId;
            //   double lat = detail.result.geometry.location.lat;
            //   double lng = detail.result.geometry.location.lng;
            //   model.latitude = lat.toString();
            //   model.longitude = lng.toString();
            //
            //   model.setAreaName(detail.result.formattedAddress);
            //   setState(() {});
            //   print("lat $lat");
            //   print("lng $lng");
            // }
          },
        ),
      );
    },
  );
}

void onError(PlacesAutocompleteResponse response) {
  print('response.errorMessage ${response.errorMessage}');
}

void getGooglePlaceData() async {
  // final uri = Constants.BASE_URL + 'endpoint';
  // final headers = {'Content-Type': 'application/x-www-form-urlencoded'};//if required
  // Response getResponse = await get(uri, headers: headers);
  // int statusCode = getResponse.statusCode;
  // String responseBody = getResponse.body;
  // print('response----' + responseBody);
}

Future<Null> displayPrediction(Prediction p, model) async {
  if (p != null) {
    print("PlaceID ${p.placeId}");
    // PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    // print("detail ${detail.errorMessage}");
    // var placeId = p.placeId;
    // double lat = detail.result.geometry!.location.lat;
    // double lng = detail.result.geometry!.location.lng;
    // model.setAreaName(detail.result.formattedAddress);
    //
    // print("lat $lat");
    // print("lng $lng");
  }
}

Widget addressTypeTextField(model) {
  return AllInputDesign(
    controller: model.addressTypeController,
    fillColor: Colors.grey.withOpacity(0.2),
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    hintText: 'Address Type',
    validatorFieldValue: 'Address Type',
    // validator: validateEmailField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget homeTextField(model) {
  return AllInputDesign(
    controller: model.homeController,
    fillColor: Colors.grey.withOpacity(0.2),
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    hintText: 'House *',
    validatorFieldValue: 'House',
    validator: validateHome,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget blockTextField(model) {
  return AllInputDesign(
    controller: model.blockTextFieldController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Block *',
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    validatorFieldValue: 'Block',
    validator: validateBlock,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget streetTextField(model) {
  return AllInputDesign(
    controller: model.streetTextFieldController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Street *',
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    validator: validateStreet,
    validatorFieldValue: 'Street',
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget addressNameTextField(model) {
  return AllInputDesign(
    controller: model.addressNameTextFieldController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Address Name',
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    validatorFieldValue: 'Address Name',
    // validator: validateAddressName,
    keyBoardType: TextInputType.text,
  );
}

Widget avenueTextField(model) {
  return AllInputDesign(
    controller: model.avenueTextFieldController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Avenue',
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    validatorFieldValue: 'Avenue',
    // validator: validateAvenue,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget buildingTextField(model) {
  return AllInputDesign(
    controller: model.buildingTextFieldController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Building *',
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    validator: validateBuilding,
    validatorFieldValue: 'Building',
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget floorTextField(model) {
  return AllInputDesign(
    controller: model.floorTextFieldController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Floor',
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    // validator: validateFloor,
    validatorFieldValue: 'Floor',
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget officeTextField(model) {
  return AllInputDesign(
    controller: model.officeTextFieldController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Office',
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    validatorFieldValue: 'Office',
    // validator: validateOffice,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget apartmentNoTextField(model) {
  return AllInputDesign(
    controller: model.apartmentNoTextFieldController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Apartment No.',
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    // validator: validateAppartmentNo,
    validatorFieldValue: 'Apartment No.',
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget addMobTextField(model) {
  return AllInputDesign(
    controller: model.addMobTextFieldController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Mobile Number *',
    cursorColor: Colors.black,
    maxLength: 8,
    textStyleColors: Colors.black,
    prefixText: '+965 ',
    // prefixIcon
    prefixStyle: TextStyle(
      fontSize: 17,
      color: Colors.black,
    ),
    validator: validateMobile,
    counterText: '',
    validatorFieldValue: 'Mobile Number',
    keyBoardType: TextInputType.number,
  );
}

Widget extraInstruction(model) {
  return AllInputDesign(
    controller: model.extraInstructionController,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Extra Instruction',
    cursorColor: Colors.black,
    textStyleColors: Colors.black,
    validatorFieldValue: 'Extra Instruction',
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget saveAddBtn(
  BuildContext context,
  model,
  user_id,
  orderData,
  coupenData,
  orderId, updateOrder
) {
  return Button(
    buttonName: 'Save',
    btnWidth: double.infinity,
    decoration: BorderRadius.circular(15.0),
    btnColor: Color(0xff2995cc),
    color: Color(0xff2995cc),
    onPressed: () {
      if (model.areaName == '') {
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
                        "Please select Area",
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
      else {
        if (formKey.currentState!.validate()) {
          model.saveAddressOptions(
            context,
            user_id,
            orderData,
            coupenData,
            orderId, updateOrder
          );
        }
      }

      // model.saveAddressOptions(context);
    },
  );
}

// Widget selectDeliveryAddress(){
//   return
// }
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
