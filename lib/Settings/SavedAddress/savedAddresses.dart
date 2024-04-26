import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSMyAddressListRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Settings/SavedAddress/savedOrderWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedAddresses extends StatefulWidget {
  @override
  _SavedAddressesState createState() => _SavedAddressesState();
}

class _SavedAddressesState extends State<SavedAddresses> {
  var user_id;
  var get_print_type;
  bool _isLoading = false;
  List myAddresses = [];
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getValuesSF();
      await getMyAddressList();
    });
    super.initState();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      setState(
        () {
          user_id = json.decode(prefs.getString('login_user_id')!);
          get_print_type = json.decode(prefs.getString('set_print_type')!);
        },
      );
    }
  }

  @override
  getMyAddressList() async {
    // progressHUD.state.show();
    var otpRequest = WSMyAddressListRequest(
      endPoint: APIManager.endpoint,
      userID: user_id.toString(),
    );
    await APIManager.performRequest(otpRequest, showLog: true);

    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        setState(() {
          // myAddresses = dataResponse['data'];
        });
        // progressHUD.state.dismiss();
      } else {
        // progressHUD.state.dismiss();
        // var messages = dataResponse['msg'];
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: new Text('Message'),
        //       content: Row(
        //         children: [
        //           Icon(
        //             Icons.error_outline,
        //             color: Colors.red,
        //           ),
        //           widthSizedBox(5.0),
        //           Text(
        //             messages,
        //             textAlign: TextAlign.center,
        //             maxLines: 2,
        //             // overflow: TextOverflow.ellipsis,
        //           ),
        //         ],
        //       ),
        //       actions: <Widget>[
        //         FlatButton(
        //           child: new Text("OK"),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        'Saved Addresses',
        context,
        Text(
          '----------',
          style: TextStyle(
            color: Colors.transparent,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/img1.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      addressList(context, myAddresses),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // progressHUD,
        ],
      ),
      bottomNavigationBar: submitBtn(context),
    );
  }
}
