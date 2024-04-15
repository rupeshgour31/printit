import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/toast.dart';
import 'package:printit_app/OrderDetails/order_details.dart';
import 'package:dio/dio.dart';

Widget printiesListView(
  printiesList,
  context,
  model,
  projectName,
  orderType,
) {
  print('kkkkk ${printiesList}');
  return Container(
    height: MediaQuery.of(context).size.height * 0.85,
    child: printiesList.length == 0
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: printiesList.length,
            itemBuilder: (BuildContext context, int index) {
              var currentOption = printiesList[index];
              var selectedPrintID = "";
              if (model.productSelctTocheckout != null) {
                selectedPrintID = model.productSelctTocheckout["id"];
              }
              print(" printiesList ${printiesList[index]}");
              return GestureDetector(
                onTap: () {
                  model.selectShopType(
                    printiesList[index],
                    projectName,
                    orderType,
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  width: 180.0,
                  height: 120,
                  padding: EdgeInsets.only(
                    left: 5.0,
                    top: 5.0,
                    right: 15.0,
                    bottom: 5.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                    color: (selectedPrintID == currentOption["id"])
                        ? whiteColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              heightSizedBox(10.0),
                                Text(
                                printiesList[index]['currency'] ?? 'KD',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: whiteColor,
                                  fontFamily: 'Nunito',
                                ),
                                maxLines: 1,
                              ),
                              heightSizedBox(2.0),

                              Text(
                                printiesList[index]['vendor_charge']
                                        .toString() ??
                                    '',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: whiteColor,
                                  fontFamily: 'Nunito-Bold',
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                printiesList[index]['shop_name'] ?? '',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      (selectedPrintID == currentOption["id"])
                                          ? Colors.blue
                                          : whiteColor,
                                  fontFamily: 'Nunito-Bold',
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),

                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                '${printiesList[index]['start_time'].substring(0, 5)} - ${printiesList[index]['end_time'].substring(0, 5)}' ??
                                    '',
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      (selectedPrintID == currentOption["id"])
                                          ? Colors.blue
                                          : whiteColor,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      (selectedPrintID == currentOption["id"]) ?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset('assets/images/tick.png'),
                                ),
                                Text(
                                  "Selected",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontFamily: 'Nunito',
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ) : Container(
                        width: 60,
                        child:  Text(
                            printiesList[index]['building'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Nunito',
                            ),
                          maxLines: 2,
                      ),)
                    ],
                  ),
                ),
              );
            },
          ),
  );
}

Widget bottomNavContainer(
  msg,
  context,
  model,
  order_id,
  projectName,
  updateOrder,
) {
  return Container(
    padding: EdgeInsets.only(
      right: 15.0,
      left: 15.0,
      bottom: 3,
    ),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          'assets/images/img1.png',
        ),
        fit: BoxFit.cover,
      ),
    ),
    child: msg != null
        ? Text('')
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Image.asset(
                  'assets/images/12.png',
                ),
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.2,
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
                      model.productSelctTocheckout != null
                          ? updateOrder(model)
                          : Constants.showToast('Please Select Printery shop.');
                    },
                  ),
                ),
              )
            ],
          ),
  );
}
