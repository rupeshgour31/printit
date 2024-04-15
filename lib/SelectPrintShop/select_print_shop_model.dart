import 'package:flutter/material.dart';

class SelectPrintShopModel extends ChangeNotifier {
  double opacityLevel = 1.0;
  Map productSelctTocheckout;
  selectShopType(printiesMap, projectName, orderType) {
    productSelctTocheckout = printiesMap;
    productSelctTocheckout.putIfAbsent('project_name', () => projectName);
    productSelctTocheckout.putIfAbsent('order_type', () => orderType);
    // productSelctTocheckout.add({'project_name': 'projectName'.toString()};
    notifyListeners();
  }

  void changeOpacity() {
    opacityLevel = opacityLevel == 0.6 ? 1.0 : 0.6;
    notifyListeners();
  }

  void initTask(context) async {
    notifyListeners();
  }
}
