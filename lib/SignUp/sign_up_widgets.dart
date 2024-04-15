import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:printit_app/Common/button.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/my_text_field.dart';
import 'package:printit_app/Common/validations_field.dart';

import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyBe0j7QlQQeRTlMdzJIdfPCvhRLq9Ks3js";

Widget signUpFirstName(model) {
  return AllInputDesign(
    key: Key("first name"),
    controller: model.signUpFirstName,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'First Name',
    validatorFieldValue: 'First Name',
    validator: validateName,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget signUpLastName(model) {
  return AllInputDesign(
    key: Key("last name"),
    controller: model.signUpLastName,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Last Name',
    validatorFieldValue: 'Last Name',
    validator: validateName,
    keyBoardType: TextInputType.emailAddress,
  );
}
void onError(PlacesAutocompleteResponse response) {
  print('response.errorMessage ${response.errorMessage}');
}
Widget signUpAddress(model) {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);


    Mode _mode = Mode.overlay;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Button(
            buttonName: (model.areaName != '') ? model.areaName : 'Select Area *',
            btnWidth: double.infinity,
            btnHeight: 50,
            decoration: BorderRadius.circular(15.0),
            textColor: Colors.white,
            color: Color.fromRGBO(255, 255, 255, 0.2),
            onPressed: () async {
              // show input autocomplete with selected mode
              // then get the Prediction selected
              Prediction p = await PlacesAutocomplete.show(
                context: context,
                apiKey: kGoogleApiKey,
                onError: onError,
                mode: _mode,
                language: "en",
                components: [Component(Component.country, "kw")],
              );
              if (p != null) {
                print("PlaceID ${p.placeId}");
                PlacesDetailsResponse detail =
                await _places.getDetailsByPlaceId(p.placeId);
                print("detail ${detail.errorMessage}");
                var placeId = p.placeId;
                double lat = detail.result.geometry.location.lat;
                double lng = detail.result.geometry.location.lng;
                model.latitude = lat.toString();
                model.longitude = lng.toString();

                model.setAreaName(detail.result.formattedAddress);
                setState(() {});
                print("lat $lat");
                print("lng $lng");
              }
            },
          ),
        );
      },
    );

}

Widget signUpEmail(model) {
  return AllInputDesign(
    key: Key("email"),
    controller: model.signUpEmail,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Email',
    validatorFieldValue: 'email',
    validator: validateEmailField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget signUpMobile(model) {
  return AllInputDesign(
    key: Key("mobile"),
    controller: model.signUpMobile,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'Mobile',
    validatorFieldValue: 'Mobile',
    validator: validateMobile,
    prefixText: '+965 ',
    prefixStyle: TextStyle(
      color: whiteColor,
      fontSize: 16,
    ),
    maxLength: 8,
    counterText: '',
    keyBoardType: TextInputType.number,
  );
}

Widget signUpPassword(model) {
  return AllInputDesign(
    key: Key("password"),
    controller: model.signUpPassword,
    fillColor: Colors.grey.withOpacity(0.2),
    hintText: 'password',
    obsecureText: model.obscureText,
    suffixIcon: GestureDetector(
      key: Key('password_visibility'),
      child: Icon(
        model.obscureText ? Icons.visibility : Icons.visibility_off,
        size: 20.0,
        color: whiteColor,
      ),
      onTap: () {
        model.toggle();
      },
    ),
    validatorFieldValue: 'password',
    validator: validatePassword,
    keyBoardType: TextInputType.text,
  );
}

Widget doneSignUp(BuildContext context, formKey, model, languageType) {
  return Button(
    btnWidth: double.infinity,
    buttonName: languageType == 'arabic' ? 'التسجيل' : 'Done',
    key: Key('login_submit'),
    decoration: BorderRadius.circular(15.0),
    btnColor: Color(0xff2995cc),
    color: Color(0xff2995cc),
    onPressed: () {
      if (formKey.currentState.validate()) {
        model.signUpUser(context);
        // Navigator.pushNamed(context, '/homePage');
      }
    },
  );
  // return GestureDetector(
  //   child: Container(
  //     width: double.infinity,
  //     height: 65,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20.0),
  //         topRight: Radius.circular(20.0),
  //       ),
  //       color: Color(0xff2995cc),
  //     ),
  //     child: Center(
  //       child: Text(
  //         'DONE',
  //         style: TextStyle(
  //           fontSize: 25.0,
  //           fontFamily: 'Nunito',
  //           fontWeight: FontWeight.w400,
  //           color: whiteColor,
  //         ),
  //       ),
  //     ),
  //   ),
  //   onTap: () {
  //     if (formKey.currentState.validate()) {
  //       model.submit(context);
  //     }
  //   },
  // );
}
