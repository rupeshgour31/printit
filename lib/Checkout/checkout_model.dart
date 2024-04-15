import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSAddNewAddressRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:printit_app/Checkout/checkout_one.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/toast.dart';

class CheckoutModel extends ChangeNotifier {

  var areaName = '';
  var latitude = '';
  var longitude = '';

  bool checkoutBtnPress = true;
  bool continueOderBtnPress = false;
  bool savedOrderBtnPress = false;
  List mySavedAddresses = [];
  var myAddressesToShow;
  var myAddressesId;
  TextEditingController areaTextFieldController = TextEditingController();
  TextEditingController addressTypeController = TextEditingController();
  TextEditingController blockTextFieldController = TextEditingController();
  TextEditingController streetTextFieldController = TextEditingController();
  TextEditingController officeTextFieldController = TextEditingController();
  TextEditingController addressNameTextFieldController =
      TextEditingController();
  TextEditingController avenueTextFieldController = TextEditingController();
  TextEditingController buildingTextFieldController = TextEditingController();
  TextEditingController homeController = TextEditingController();
  TextEditingController floorTextFieldController = TextEditingController();
  TextEditingController apartmentNoTextFieldController =
      TextEditingController();
  TextEditingController addMobTextFieldController = TextEditingController();
  TextEditingController extraInstructionController = TextEditingController();

  selectAddTypes(int index) {
    myAddressesToShow = mySavedAddresses[index]['address_type'];
    myAddressesId = mySavedAddresses[index]['id'] ?? '';
    notifyListeners();
  }

  setAreaName(areaString) {
    areaName = areaString;
    notifyListeners();
  }


  btnOnTap(String type) {
    if (type == 'checkout') {
      checkoutBtnPress = true;
      continueOderBtnPress = false;
      savedOrderBtnPress = false;
    } else if (type == 'continue shopping') {
      checkoutBtnPress = false;
      continueOderBtnPress = true;
      savedOrderBtnPress = false;
    } else {
      checkoutBtnPress = false;
      continueOderBtnPress = false;
      savedOrderBtnPress = true;
    }
    notifyListeners();
  }

  saveMyAdd(myAddressesList) {
    mySavedAddresses = myAddressesList;
    notifyListeners();
  }

  var addType = 'home';
  saveAddressOptions(
    context,
    user_id,
    orderData,
    coupenData,
    orderId,
      orderUpdate
  ) async {
    var otpRequest = WSAddNewAddressRequest(
      endPoint: APIManager.endpoint,
      user_id: user_id,
      // label: addressNameTextFieldController.text,
      // address: addressNameTextFieldController.text,
      // additional_directions: addressNameTextFieldController.text,
      address_type: addType,
      apartment_no: apartmentNoTextFieldController.text,
      avenue: avenueTextFieldController.text,
      block: blockTextFieldController.text,
      building: buildingTextFieldController.text,
      house: homeController.text,
      address: areaName,
      label: addressNameTextFieldController.text,
      mobile: addMobTextFieldController.text,
      street: streetTextFieldController.text,
      office: officeTextFieldController.text,
      floor: floorTextFieldController.text,
      latitude: latitude,
      longitude: longitude

    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        Map addressDetail = dataResponse["address_detail"];
        Constants.showToast('Address Added Successfully');
        //

        myAddressesId = addressDetail["id"];
        myAddressesToShow = addressDetail["address_type"];
        areaName = '';
        latitude = '';
        longitude = '';
        addressNameTextFieldController.clear();
        apartmentNoTextFieldController.clear();
        avenueTextFieldController.clear();
        blockTextFieldController.clear();
        buildingTextFieldController.clear();
        homeController.clear();
        addMobTextFieldController.clear();
        streetTextFieldController.clear();
        officeTextFieldController.clear();
        floorTextFieldController.clear();
        orderUpdate(myAddressesId.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutOne(
              orderData: orderData,
              pickup_delivery: '2',
              order_id: orderId,
              couponData: coupenData,
              isFromAdd: true,
            ),
          ),
        );

      } else {
        var messages = dataResponse['msg'];
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

  void initTask(context) async {

    checkoutBtnPress = true;
    continueOderBtnPress = false;
    savedOrderBtnPress = false;
    notifyListeners();
  }
}
