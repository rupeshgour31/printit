import 'package:flutter/material.dart';
import 'package:printit_app/AboutPrintIt/about_print_it.dart';
import 'package:printit_app/AccountInfo/account_info.dart';
import 'package:printit_app/AccountInfo/account_info_model.dart';
import 'package:printit_app/Banner/banner.dart';
import 'package:printit_app/Checkout/checkout_model.dart';
import 'package:printit_app/Checkout/checkout_one.dart';
import 'package:printit_app/CustomPrint/custom_print.dart';
import 'package:printit_app/Checkout/checkout_three.dart';
import 'package:printit_app/Checkout/checkout_fail.dart';
import 'package:printit_app/Checkout/checkout_two.dart';
import 'package:printit_app/Checkout/InAppWebview.dart';
import 'package:printit_app/Dashboard/dashboard.dart';
import 'package:printit_app/Design/design.dart';
import 'package:printit_app/Dashboard/order_status.dart';
import 'package:printit_app/Flyer/flyer.dart';
import 'package:printit_app/ForgotPassword/forgot_password1.dart';
import 'package:printit_app/ForgotPassword/forgot_password2.dart';
import 'package:printit_app/ForgotPassword/forgot_password_model.dart';
import 'package:printit_app/Home/home_page.dart';
import 'package:printit_app/LogIn/login_model.dart';
import 'package:printit_app/Notes/NotesList/notes_list.dart';
import 'package:printit_app/Notes/NotsView/notes_view.dart';
import 'package:printit_app/OrderDetails/order_details.dart';
import 'package:printit_app/OrderDetails/order_details_model.dart';
import 'package:printit_app/Orders/orders.dart';
import 'package:printit_app/Poster/poster.dart';
import 'package:printit_app/Poster/poster_model.dart';
import 'package:printit_app/PrivacyPolicy/privacy_policy.dart';
import 'package:printit_app/ResetPassword/reset_password.dart';
import 'package:printit_app/Rollup/rollup.dart';
import 'package:printit_app/SelectPrintShop/select_print_shop.dart';
import 'package:printit_app/SelectPrintShop/select_print_shop_model.dart';
import 'package:printit_app/Settings/settings.dart';
import 'package:printit_app/SignUp/sign_up.dart';
import 'package:printit_app/SignUp/sign_up_model.dart';
import 'package:printit_app/SplashScreen/splash_screen.dart';
import 'package:printit_app/TAndC/terms_and_condition.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ForgotPasswordModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AccountInfoModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignUpModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CheckoutModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PosterModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectPrintShopModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderDetailsModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrintIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Nunito',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/resetPassword': (context) => ResetPassword(),
        '/forgotPassword1': (context) => ForgotPassword1(),
        '/forgotPassword2': (context) => ForgotPassword2(),
        '/settings': (context) => Settings(),
        '/aboutPrintIt': (context) => AboutPrintIt(),
        '/privacyPolicy': (context) => PrivacyPolicy(),
        '/accountInfo': (context) => AccountInfo(),
        '/signUp': (context) => SignUp(),
        // '/checkoutOne': (context) => CheckoutOne(),
        // '/checkoutTwo': (context) => CheckoutTwo(),
        // '/checkoutThree': (context) => CheckoutThree(),
        // Dashboard.routeName: (context) => Dashboard(),
        '/dashboard': (context) => Dashboard(),
        '/orderStatus': (context) => OrderStatus(),
        '/customPrint': (context) => CustomPrint(),
        '/poster': (context) => Poster(),
        '/banner': (context) => Banners(),
        '/flyer': (context) => Flyer(),
        '/rollup': (context) => Rollup(),
        '/designPage': (context) => Design(),
        '/ordersPage': (context) => Orders(),
        '/selectPrintShop': (context) => SelectPrintShop(),
        '/notes_list': (context) => NotesList(),
        '/termsAndCondition': (context) => TermsAndCondition(),
        '/inAppWebview': (context) => InAppWebview(),
        // OrderDetails.routeName: (context) => OrderDetails(),
        // NotesView.routeName: (context) => NotesView(),
        HomePage.routeName: (context) => HomePage(),
        CheckoutThree.routeName: (context) => CheckoutThree(),
        CheckoutTwo.routeName: (context) => CheckoutTwo(),
        CheckoutFail.routeName: (context) => CheckoutFail(),

      },
    );
  }
}
