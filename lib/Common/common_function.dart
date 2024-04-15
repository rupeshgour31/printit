import 'package:flutter/material.dart';

class CommonFunctions {
  convertKey(text) {
    var removedSteps = text.toString().toLowerCase().replaceAll(' ', '_');
    return removedSteps;
  }
}
