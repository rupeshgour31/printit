import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';

Widget posterTopImage(model, context) {
  return Stack(
    children: [
      Container(
        margin: EdgeInsets.only(top: 80.0),
        height: 70,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.blue[400],
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 150.0,
          width: 230,
          child: Image.asset(
            'assets/images/poster.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    ],
  );
}

Widget listDemo(context, model) {
  return Container(
    child: IconButton(
      icon: Icon(
        Icons.check,
        color: whiteColor,
      ),
      onPressed: () {
        // chooseQnantity(context, model);
      },
    ),
  );
}

Widget paperqnt(context, model) {
  return Container(
    child: IconButton(
      icon: Icon(
        Icons.assistant_rounded,
        color: whiteColor,
      ),
      onPressed: () {
        // selectPaperTypeBottomSheet(context, model);
      },
    ),
  );
}

Widget designPoster(context, model) {
  return Container(
    child: IconButton(
      icon: Icon(
        Icons.design_services,
        color: whiteColor,
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/designPage');
      },
    ),
  );
}
