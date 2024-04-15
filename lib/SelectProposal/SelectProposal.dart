import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSAcceptProposalRequest.dart';
import 'package:printit_app/Api/Request/WSGetAcceptProposalsListRequest.dart';
import 'package:printit_app/Api/api_manager.dart';
import 'package:printit_app/Checkout/checkout_one.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/toast.dart';

class SelectProposal extends StatefulWidget {
  final orderData;

  SelectProposal(
    this.orderData,
  );

  @override
  _SelectProposalState createState() => _SelectProposalState();
}

class _SelectProposalState extends State<SelectProposal> {
  bool isSelect = false;
  List getProposals = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      getProposalsList();
    });
    super.initState();
  }

  void getProposalsList() async {
    progressHUD.state.show();
    var otpRequest = WSGetAcceptProposalsListRequest(
      endPoint: APIManager.endpoint,
      orderId: widget.orderData['id'].toString(),
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        setState(() {
          getProposals = dataResponse['data'];
        });
        progressHUD.state.dismiss();
      } else {
        var messages = dataResponse['msg'];
        progressHUD.state.dismiss();
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

  Map productSelctTocheckout;

  void selectPrintry(printry) {
    setState(() {
      productSelctTocheckout = printry;
    });
  }

  @override
  void acceptProposal(printryIdGet, shop_name) async {
    progressHUD.state.show();
    var otpRequest = WSAcceptProposalRequest(
      endPoint: APIManager.endpoint,
      orderId: widget.orderData['id'].toString(),
      printryId: printryIdGet,
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['success'] == true) {
        progressHUD.state.dismiss();
        Navigator.pushNamed(
          context,
          '/checkoutTwo',
          arguments: {
            'orderData': {
              'order_type': '5',
              'shop_name': shop_name.toString(),
            },
            'pickup_delivery': '2',
            'translation_proposal_accept': 'yes',
            'order_id': widget.orderData['id'],
          },
        );
      } else {
        var messages = dataResponse['msg'];
        progressHUD.state.dismiss();
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

  printerySelected() async {
    acceptProposal(
      productSelctTocheckout['printery_id'],
      productSelctTocheckout['shop_name'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        'Proposals',
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
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 25.0,
                    left: 25.0,
                    right: 25.0,
                  ),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height,
                    child: getProposals.length == 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 150.0),
                            child: Text(
                              'Order Id #${widget.orderData['id'].toString()}\nWaiting For Proposals',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color(0xff00b940),
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: getProposals.length,
                            itemBuilder: (BuildContext context, int index) {
                              var currentOption = getProposals[index];
                              var selectedPrintID = "";
                              if (productSelctTocheckout != null) {
                                selectedPrintID =
                                    productSelctTocheckout["printery_id"];
                              }
                              return GestureDetector(

                                onTap: () {
                                  setState(
                                    () {
                                      selectPrintry(getProposals[index]);

                                    },
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top:8, bottom:8),
                                  width: 300.0,
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
                                    color: (selectedPrintID ==
                                            currentOption["printery_id"])
                                        ? whiteColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              heightSizedBox(10.0),
                                              Text(
                                                getProposals[index]
                                                        ['currency'] ??
                                                    'KD',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: whiteColor,
                                                  fontFamily: 'Nunito',
                                                ),
                                                maxLines: 1,
                                              ),
                                              heightSizedBox(2.0),
                                              Text(
                                                getProposals[index]
                                                            ['vendor_charge']
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Text(
                                                getProposals[index]
                                                        ['shop_name'] ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: (selectedPrintID ==
                                                          currentOption["printery_id"])
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Text(
                                                '${getProposals[index]['start_time'].substring(0, 5)} - ${getProposals[index]['end_time'].substring(0, 5)}' ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: (selectedPrintID ==
                                                          currentOption["printery_id"])
                                                      ? Colors.blue
                                                      : whiteColor,
                                                  fontFamily: 'Nunito',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      (selectedPrintID == currentOption["printery_id"])
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: Image.asset(
                                                      'assets/images/tick.png'),
                                                ),
                                                Text(
                                                  "Selected",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blue,
                                                    fontFamily: 'Nunito',
                                                  ),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            )
                                          : Container(
                                              width: 50,
                                              child: Text(
                                                getProposals[index]
                                                        ['building'] ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontFamily: 'Nunito',
                                                ),
                                                maxLines: 2,
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ),
          ),
          progressHUD,
        ],
      ),
      bottomNavigationBar: bottomNavContainer(
        context,
        printerySelected,
      ),
    );
  }
  Widget bottomNavContainer(
      context,
      printerySelected,
      ) {
    return Container(
      padding: EdgeInsets.only(
        right: 15.0,
        left: 15.0,
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/img1.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child:  Row(
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
                  productSelctTocheckout != null
                      ? printerySelected()
                      : Constants.showToast('Please Select a Proposal');
                },
              ),
            ),
          )
        ],
      ),
    );
  }

}
