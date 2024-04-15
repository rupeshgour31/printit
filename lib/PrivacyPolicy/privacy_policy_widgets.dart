import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';

Widget titleText() {
  return Text(
    'Title',
    style: TextStyle(
      fontSize: 18.0,
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w400,
      color: whiteColor,
    ),
  );
}

Widget updateAt() {
  return Text(
    'Updated 20 - 10 -20',
    style: TextStyle(
      fontSize: 15.0,
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w400,
      color: whiteColor,
    ),
  );
}

Widget privacyText() {
  return Text(
    '''
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
Lorem ipsum dolor sit amet, consetetur
    ''',
    style: TextStyle(
      fontSize: 16.0,
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w400,
      color: whiteColor,
    ),
  );
}
