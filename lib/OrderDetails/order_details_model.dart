import 'package:flutter/material.dart';

class OrderDetailsModel extends ChangeNotifier {
  bool pickUpBtn = false;
  Map productQnt = {};
  bool deliveryBtn = false;
  double totalProductPrice = 0;
  TextEditingController orderDetailsPromoCode = TextEditingController();
  qntIncrease(productObj) {


    var currentProductQuantity = 0;
    if (productQnt[productObj['id']] != null) {
      currentProductQuantity = productQnt[productObj['id']];
      print("currentProductQuantity $currentProductQuantity");
      currentProductQuantity++;
    }

    productQnt.update(
      productObj['id'],
      (existingValue) => currentProductQuantity,
      ifAbsent: () => 1,
    );
    notifyListeners();
  }

  qntDecrease(productObj) {


    var currentProductQuantity = 0;
    if (productQnt[productObj['id']] != null) {
      currentProductQuantity = productQnt[productObj['id']];
      print("currentProductQuantity $currentProductQuantity");
      currentProductQuantity--;
    }
    productQnt.update(
      productObj['id'],
      (existingValue) => currentProductQuantity,
      ifAbsent: () => currentProductQuantity,
    );
    notifyListeners();
  }

  btnOnTap(String type) {
    if (type == 'pickup') {
      pickUpBtn = true;
      deliveryBtn = false;
    } else {
      pickUpBtn = false;
      deliveryBtn = true;
    }

    notifyListeners();
  }

  void initTask(context) async {
    print('clean data call');
    pickUpBtn = false;
    productQnt = {};
    deliveryBtn = true;
    notifyListeners();
  }
}
