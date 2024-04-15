import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';

Widget addressList(context, myAddresses) {
  return Container(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: myAddresses.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => NotesView(
            //       notes_id: _searchResult[index].id,
            //     ),
            //   ),
            // );
            // searchController.clear();
          },
          child: Container(
            padding: EdgeInsets.only(left: 2.0),
            margin: EdgeInsets.all(8.0),
            width: 180.0,
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 0.5,
              ),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: Text(
                myAddresses[index]['address_type'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: whiteColor,
                  fontFamily: 'Nunito',
                ),
                maxLines: 2,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    myAddresses[index]['label'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: whiteColor,
                      fontFamily: 'Nunito',
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                  ),
                  widthSizedBox(8.0),
                  Container(
                    height: double.infinity,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      color: Color(0xffe50914),
                    ),
                    child: Image.asset(
                      'assets/icons/Trash.png',
                      color: whiteColor,
                    ),
                  )
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment:
            //       MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Row(
            //       mainAxisAlignment:
            //           MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment:
            //           CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           myAddresses[index]['address_type'] ??
            //               '',
            //           style: TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold,
            //             color: whiteColor,
            //             fontFamily: 'Nunito',
            //           ),
            //           maxLines: 2,
            //         ),
            //         Text(
            //           myAddresses[index]['label'] ?? '',
            //           style: TextStyle(
            //             fontSize: 15,
            //             color: whiteColor,
            //             fontFamily: 'Nunito',
            //           ),
            //           maxLines: 3,
            //           textAlign: TextAlign.justify,
            //           overflow: TextOverflow.ellipsis,
            //         ),
            //       ],
            //     ),
            //     Container(
            //       height: double.infinity,
            //       width: 50,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.only(
            //           topRight: Radius.circular(8),
            //           bottomRight: Radius.circular(8),
            //         ),
            //         color: Colors.red,
            //       ),
            //       child: Image.asset(
            //         'assets/icons/Trash.png',
            //         color: whiteColor,
            //       ),
            //     )
            //   ],
            // ),
          ),
        );
      },
    ),
  );
}

Widget submitBtn(context) {
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/img1.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Color(0xff2995cc),
        ),
        child: Center(
          child: Text(
            'DONE',
            style: TextStyle(
              fontSize: 25.0,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              color: whiteColor,
            ),
          ),
        ),
      ),
    ),
    onTap: () {
      // if (formKey.currentState.validate()) {
      //   forgotPassReq(context);
      // }
    },
  );
}
