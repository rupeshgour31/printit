import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:printit_app/Common/common_widgets.dart';

Widget cameraUploadBtnAndSizeText(model, context, shouldShowCamera, isGalleryPicker) {
  return Padding(
    padding: EdgeInsets.only(left: 20.0, right: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        shouldShowCamera ?
        GestureDetector(
          onTap: model.takeCameraPic,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.lightBlue.withOpacity(0.4),
              border: Border.all(
                color: Colors.lightBlue,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.camera_alt_outlined,
                color: whiteColor,
              ),
            ),
          ),
        ) : Container(),
        GestureDetector(
          onTap: () => {
            (isGalleryPicker) ? model.takeGallaryPic(context) : model.openFileExplorer(context)
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.lightBlue.withOpacity(0.4),
                border: Border.all(
                  color: Colors.lightBlue,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward_outlined,
                      color: whiteColor,
                      size: 25.0,
                    ),
                    widthSizedBox(3.0),
                    Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: (isGalleryPicker) ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.28 ,
          child: Text(
            model.image == null
                ? 'Max File Size 20 MB'
                : model.image.path.split("/").last.toString(),
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              color: model.image == null ? Colors.grey.withOpacity(0.7) : Colors.green,
            ),
            maxLines: 2,
          ),
        )
      ],
    ),
  );
}

Widget imageContainer(model, context, isBanner, isGalleryPicker) {
  var isDocFileImage = false;
  var extension = "";
  if (model.fileName != null) {
    extension = model.fileName.split(".").last;
    print("extension extension extension $extension");
    if (extension == "png" || extension == "jpg" || extension == "PNG" || extension == "JPG" || extension == "jpeg" || extension == "JPG") {
      isDocFileImage = true;
    }
  }
  return Stack(
    children: [
      Container(
        margin: EdgeInsets.only(top: (isBanner) ? 80 : 0),
        height: (isBanner) ? MediaQuery.of(context).size.width * 0.75 : MediaQuery.of(context).size.height * 0.65,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 15.0,
            color: Colors.grey,
          ),
          shape: BoxShape.rectangle,
          color: whiteColor,
        ),
        child: Center(
          widthFactor: 200,
          child: model.image == null
              ? Text(
                  'Upload Your Design',
                  style: TextStyle(
                    fontSize: 27.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                )
              : (isGalleryPicker || isDocFileImage) ? Image.file(
                  model.image,
                  width: double.infinity,
                  height: double.infinity,
                ) : Text(
            'Your file has been uploaded Successfully',
            style: TextStyle(
              fontSize: 27.0,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ) ,
        ),
      ),
      // Align(
      //   heightFactor: 11,
      //   alignment: Alignment.bottomCenter,
      //   child: Container(
      //     height: 20.0,
      //     width: 20.0,
      //     decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       color: Colors.black45,
      //     ),
      //     child: IconButton(
      //       icon: Icon(Icons.add),
      //       onPressed: null,
      //     ),
      //   ),
      // )
    ],
  );
}
