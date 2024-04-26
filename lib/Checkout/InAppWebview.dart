import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

class InAppWebview extends StatefulWidget {
  @override
  _InAppWebview createState() => new _InAppWebview();
}

class _InAppWebview extends State<InAppWebview> {
  @override
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  Widget build(BuildContext context) {
    final  orderDetails = ModalRoute.of(context)!.settings.arguments;
    print("Bhumit $orderDetails");
    var paymentUrl = "http://tenspark.com/printit/api/payment_webview/";
    //+orderDetails["orderDetails"]["order_id"].toString();
    print("Bhumit paymentUrl $paymentUrl");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Expanded(
              //   child: WebView(
              //     initialUrl: paymentUrl,
              //     javascriptMode: JavascriptMode.unrestricted,
              //     onWebViewCreated: (WebViewController webViewController) {
              //       _controller.complete(webViewController);
              //     },
              //     // TODO(iskakaushik): Remove this when collection literals makes it to stable.
              //     // ignore: prefer_collection_literals
              //     javascriptChannels: <JavascriptChannel>[
              //       _toasterJavascriptChannel(context),
              //     ].toSet(),
              //     navigationDelegate: (NavigationRequest request) {
              //       return NavigationDecision.navigate;
              //     },
              //     onPageStarted: (String url) {
              //       print('Page started loading: $url');
              //       if (url.contains("payment_success")) {
              //         Navigator.pushNamed(context, '/checkoutThree',
              //             arguments: {
              //               'orderDetails': orderDetails["orderDetails"],
              //             });
              //       } else if (url.contains("payment_fail")) {
              //         showPopup(
              //           context,
              //           Material(
              //             color: Colors.transparent,
              //             child: Container(
              //               height: 130,
              //               padding: EdgeInsets.only(left: 20.0, right: 20.0),
              //               child: Column(
              //                 children: [
              //                   Row(
              //                     mainAxisAlignment: MainAxisAlignment.end,
              //                     children: [
              //                       GestureDetector(
              //                         onTap: () => {
              //                           Navigator.of(context).pop(),
              //                           Navigator.of(context).pop(),
              //                         },
              //                         child: Icon(
              //                           Icons.close,
              //                           size: 30,
              //                           color: Colors.black,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   Row(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Icon(
              //                         Icons.error_outline,
              //                         color: Colors.red,
              //                       ),
              //                       widthSizedBox(5.0),
              //                       Text(
              //                         'Payment Failed',
              //                         style: TextStyle(
              //                           fontSize: 18.0,
              //                           fontWeight: FontWeight.bold,
              //                           color: Colors.red,
              //                           fontFamily: 'Nunito',
              //                           decoration: TextDecoration.none,
              //                         ),
              //                         maxLines: 3,
              //                         textAlign: TextAlign.center,
              //                       ),
              //                     ],
              //                   ),
              //                   heightSizedBox(20.0),
              //                   Text(
              //                     'Payment Failed, please try again later',
              //                     style: TextStyle(
              //                       fontSize: 18.0,
              //                       fontWeight: FontWeight.bold,
              //                       color: Colors.black,
              //                       fontFamily: 'Nunito',
              //                       decoration: TextDecoration.none,
              //                     ),
              //                     maxLines: 3,
              //                     textAlign: TextAlign.center,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       }
              //     },
              //     onPageFinished: (String url) {
              //       print('Page finished loading: $url');
              //       if (Platform.isIOS) {
              //         if (url.contains("payment_success")) {
              //           Navigator.pushNamed(context, '/checkoutThree',
              //               arguments: {
              //                 'orderDetails': orderDetails["orderDetails"],
              //               });
              //         } else if (url.contains("payment_fail")) {
              //           showPopup(
              //             context,
              //             Material(
              //               color: Colors.transparent,
              //               child: Container(
              //                 height: 130,
              //                 padding: EdgeInsets.only(left: 20.0, right: 20.0),
              //                 child: Column(
              //                   children: [
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.end,
              //                       children: [
              //                         GestureDetector(
              //                           onTap: () => {
              //                             Navigator.of(context).pop(),
              //                             Navigator.of(context).pop(),
              //                           },
              //                           child: Icon(
              //                             Icons.close,
              //                             size: 30,
              //                             color: Colors.black,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Icon(
              //                           Icons.error_outline,
              //                           color: Colors.red,
              //                         ),
              //                         widthSizedBox(5.0),
              //                         Text(
              //                           'Payment Failed',
              //                           style: TextStyle(
              //                             fontSize: 18.0,
              //                             fontWeight: FontWeight.bold,
              //                             color: Colors.red,
              //                             fontFamily: 'Nunito',
              //                             decoration: TextDecoration.none,
              //                           ),
              //                           maxLines: 3,
              //                           textAlign: TextAlign.center,
              //                         ),
              //                       ],
              //                     ),
              //                     heightSizedBox(20.0),
              //                     Text(
              //                       'Payment Failed, please try again later',
              //                       style: TextStyle(
              //                         fontSize: 18.0,
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.black,
              //                         fontFamily: 'Nunito',
              //                         decoration: TextDecoration.none,
              //                       ),
              //                       maxLines: 3,
              //                       textAlign: TextAlign.center,
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           );
              //           // Navigator.pushNamed(context, '/checkoutFail',
              //           //     arguments: {
              //           //       'orderDetails': orderDetails["orderDetails"],
              //           //     });
              //         }
              //       }
              //     },
              //     gestureNavigationEnabled: true,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
//   return JavascriptChannel(
//       name: 'Toaster',
//       onMessageReceived: (JavascriptMessage message) {
//         // ignore: deprecated_member_use
//         Scaffold.of(context).showSnackBar(
//           SnackBar(content: Text(message.message)),
//         );
//       });
// }
