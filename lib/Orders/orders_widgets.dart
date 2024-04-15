import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/OrderDetails/order_details.dart';
import 'package:printit_app/SelectPrintShop/select_print_shop.dart';
import 'package:intl/intl.dart';

Widget savedOrderText() {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: Text(
      'SAVED ORDERS',
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'Nunito',
        color: whiteColor,
      ),
    ),
  );
}

Widget orderHistoryText() {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: Text(
      'ORDERS HISTORY',
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'Nunito',
        color: whiteColor,
      ),
    ),
  );
}

@override
Widget savedOrders(
  BuildContext context,
  savedOrders,
  toggleSelection,
  isSelected,
  _selectedIndexList,
  selectUnselect,
) {
  return savedOrders.length == 0
      ? Center(
          child: Text(
            'No Record Found !',
            style: TextStyle(
              fontSize: 18,
              color: whiteColor.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontFamily: 'Nunito',
            ),
          ),
        )
      : Container(
          height: MediaQuery.of(context).size.height ,
          child: GridView.builder(
            controller: new ScrollController(keepScrollOffset: false),
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            itemCount: savedOrders.length,
            itemBuilder: (ctx, i) {
              return GestureDetector(
                onLongPress: () =>
                    toggleSelection(true, savedOrders[i]['order_id']),
                onTap: () => selectUnselect(savedOrders[i]['order_id']),
                child: Container(
                  margin: EdgeInsets.only(bottom: 15.0, right: 10.0),
                  padding: EdgeInsets.only(
                    left: 8.0,
                    right: 5.0,
                    top: 8.0,
                    bottom: 10.0,
                  ),
                  height: 65,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: selectColors(savedOrders[i]['order_type']),
                    border: Border.all(
                      color: _selectedIndexList
                              .contains(savedOrders[i]['order_id'])
                          ? redColor
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                  child: Stack(

                    children: [
                      Positioned(
                        top: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectType(savedOrders[i]['order_type']),
                              style: TextStyle(
                                fontSize: 17,
                                color: savedOrders[i]['order_type'] == '2' ||
                                        savedOrders[i]['order_type'] == '4'
                                    ? Colors.black
                                    : whiteColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Nunito',
                              ),
                            ),

                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,

                        child: SizedBox(
                          height: 40.0,
                          width: 40.0,
                          child: selectImage(
                            savedOrders[i]['order_type'],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 45,
                        child: Text(
                          savedOrders[i]['updated_at'].substring(0, 10),
                          style: TextStyle(
                            fontSize: 12,
                            color: savedOrders[i]['order_type'] == '2' ||
                                    savedOrders[i]['order_type'] == '4'
                                ? Colors.black
                                : whiteColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        width: 130 ,
                        child: Text(
                          savedOrders[i]['project_name'],
                          style: TextStyle(
                            fontSize: 18,
                            color: savedOrders[i]['order_type'] == '2' ||
                                    savedOrders[i]['order_type'] == '4'
                                ? Colors.black
                                : whiteColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                      ),
                      heightSizedBox(3.0),
                      Positioned(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              savedOrders[i]['order_type'] == '3'
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderDetails(
                                          orderDetail: {
                                            'order_type': '3',
                                            'project_name': savedOrders[i]
                                                ['project_name'],
                                          },
                                          order_id: savedOrders[i]['order_id'],
                                        ),
                                      ),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectPrintShop(
                                          comeFrom: 'save_order',
                                          orderId: savedOrders[i]['order_id'],
                                        ),
                                      ),
                                    );
                            },
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_outlined,
                                    color: whiteColor,
                                    size: 28.0,
                                  ),
                                  onPressed: null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  MediaQuery.of(context).size.height *
                  1.3 *
                  1.45,
              crossAxisSpacing: 2,
              mainAxisSpacing: 0.1,
            ),
          ),
        );
}

Widget orderHistoryItems(orderHistoryArray) {
  return orderHistoryArray.length == 0
      ? Center(
          child: Text(
            'No Record Found !',
            style: TextStyle(
              fontSize: 18,
              color: whiteColor.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontFamily: 'Nunito',
            ),
          ),
        )
      : Container(
          height: 200.0,
          width: 550,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: orderHistoryArray.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  print('fskldf${orderHistoryArray[index]}');
                  Navigator.pushNamed(
                    context,
                    '/checkoutThree',
                    arguments: {
                      'orderDetails': {
                        'order_id': orderHistoryArray[index]['order_id'],
                        'orderData': {
                          'price':
                              orderHistoryArray[index]['amount'].toString(),
                          'shop_name': '',
                        },
                      },
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: 180.0,
                  height: double.infinity,
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${orderHistoryArray[index]['order_id']}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff00b940),
                          fontFamily: 'Nunito',
                        ),
                      ),
                      Text(
                        orderHistoryArray[index]['updated_at'].substring(0, 10),
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      Text(
                        orderHistoryArray[index]['project_name'],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Nunito',
                        ),
                        maxLines: 2,
                      ),
                      heightSizedBox(4.0),
                      Text(
                        'KD ${orderHistoryArray[index]['order_total']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
}

selectColors(String type) {
  switch (type) {
    case '3':
      return Color(0xffd50880);
      break;
    case '2':
      return Color(0xffe6d821);
      break;
    case '1':
      return Color(0xff2995cc);
      break;
    case '4':
      return Colors.white;
      break;
    default:
      return Colors.white;
      break;
  }
}

selectType(String type) {
  switch (type) {
    case '3':
      return "Translation";
      break;
    case '2':
      return "Quick Print";
      break;
    case '1':
      return 'Custom Print';
      break;
    case '4':
      return "Notes";
      break;
    default:
      return '';
      break;
  }
}

selectImage(String type) {
  switch (type) {
    case '3':
      return Image.asset(
        'assets/icons/translation.png',
        fit: BoxFit.fill,
      );
      break;
    case '2':
      return Image.asset(
        'assets/icons/icon6.png',
        color: Colors.black,
        fit: BoxFit.fill,
      );
      break;
    case '1':
      return Image.asset(
        'assets/icons/custom_print copy11.png',
        fit: BoxFit.fill,
      );
      break;
    case '4':
      return Image.asset(
        'assets/icons/paper_icon.png',
        fit: BoxFit.fill,
        color: Colors.black,
      );
      break;
    default:
      return Image.asset(
        'assets/icons/translation.png',
        fit: BoxFit.fill,
      );
      break;
  }
}
