import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:printit_app/Common/common_widgets.dart';

Widget posterFlyerHead(context, image, heading, onPressed) {
  print(heading);
  return GestureDetector(
    onTap: onPressed,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 80.0),
              height: 65.0,
              padding: EdgeInsets.only(right: 15.0),
              width: MediaQuery.of(context).size.width * 0.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
                color: Colors.blue,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.arrow_forward,
                        size: 30.0,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Image(
            //   image: NetworkImage(
            //     carts[index]['img_url'] +
            //         '/' +
            //         carts[index]['image'],
            //   ),
            //   fit: BoxFit.fill,
            // ),
            SizedBox(
              height: 145.0,
              width: 175,
              child: Image(
                image: NetworkImage(image),
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 15.0),
          child: Text(
            heading,
            style: TextStyle(
              fontSize: 18.0,
              color: whiteColor,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget bannersRollUpHead(context, image, heading, onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 15.0),
          child: Text(
            heading,
            style: TextStyle(
              fontSize: 18.0,
              color: whiteColor,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Stack(
          children: [
            Container(
              height: 65.0,
              margin: EdgeInsets.only(top: 80.0),
              padding: EdgeInsets.only(left: 15.0),
              width: MediaQuery.of(context).size.width * 0.66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                ),
                color: Colors.blue,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30.0,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 90.0),
              child: SizedBox(
                height: 145.0,
                width: 175,
                child: Image(
                  image: NetworkImage(image),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
