import 'package:flutter/material.dart';
import 'package:printit_app/Api/Request/WSSaveQuickPrintOrderRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printit_app/Common/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class PosterModel extends ChangeNotifier {
  TextEditingController orderTitle = TextEditingController();

  var paperType;
  int _itemCount = 1;
  var itemsCount = 1;
  File? image;
  String imageSavePath = '';
  final picker = ImagePicker();

  Future takeCameraPic() async {
    // final pickedFile = await picker.getImage(source: ImageSource.camera);
    // image = File(pickedFile.path);
    // imageSavePath = pickedFile.path;
    // notifyListeners();
  }

  resetItemCount() {
    _itemCount = 1;
    itemsCount = 1;
  }
  String fileName = '';
  String path='';
  Map<String, String> paths ={};
  List<String> extensions=[];
  bool isLoadingPath = false;

  Future openFileExplorer(context) async {
     try {
      // path = await FilePicker.getFilePath(
      //     type:  FileType.any,
      //     allowedExtensions: extensions);
      // paths = null;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    print('Bhumit Path $path');
    if (path != null) {
      double fileSize =  File(path).lengthSync() / 1000000;
      print("filesiZe $fileSize");
      if (fileSize > 20) {
        showPopup(
          context,
          Material(
            color: Colors.transparent,
            child: Container(
              height: 130,
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      widthSizedBox(5.0),
                      Text(
                        'Alert',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontFamily: 'Nunito',
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  heightSizedBox(20.0),
                  Text(
                    'File size can not be more than 20 MB',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Nunito',
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      else {
        imageSavePath = path;
        image = File(path);

        isLoadingPath = false;
        fileName = path != null
            ? path.split('/').last
            : paths != null
            ? paths.keys.toString()
            : '...';
        notifyListeners();
      }


    }


  }

/*
  Future takeGallaryPic(context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print("pickedFile $pickedFile");
      var selectedFile = File(pickedFile.path);
      var decodedImage = await decodeImageFromList(selectedFile.readAsBytesSync());
      print(" decodedImage.width ${decodedImage.width}");
      print(" decodedImage.height ${decodedImage.height}");

      if (decodedImage.width > 1000 || decodedImage.height > 1000) {
        image = File(pickedFile.path);
        imageSavePath = pickedFile.path;
        notifyListeners();
      }
      else {
        showPopup(
          context,
          Material(
            color: Colors.transparent,
            child: Container(
              height: 130,
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      widthSizedBox(5.0),
                      Text(
                        'Alert',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontFamily: 'Nunito',
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  heightSizedBox(20.0),
                  Text(
                    'Please select a high resolution image',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Nunito',
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }
*/

  designUpload(context, designDetail) {
    if (image == null) {
      Constants.showToast(
        "Please add design.",
      );
    } else {
      // designDetail['selectedOptions'][2] = {
      //   'id': '4',
      //   'name': image.path.split("/").last.toString(),
      // };
      Navigator.pop(context);
    }
  }

  sheetQnt(context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: (itemsCount == 1) ? Colors.grey : Color.fromRGBO(68, 84, 97, 1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(
                    () {
                      if (_itemCount > 1) {
                        HapticFeedback.lightImpact();
                        _itemCount--;
                        itemsCount = _itemCount;
                        //       notifyListeners();
                      }
                    },
                  );
                },
              ),
            ),
            widthSizedBox(20.0),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: whiteColor,
              ),
              child: Center(
                child: Text(

                  itemsCount.toString(),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            widthSizedBox(20.0),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Color.fromRGBO(68, 84, 97, 1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(
                    () {
                      _itemCount++;
                      itemsCount = _itemCount;
                      //      notifyListeners();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void initTask(context) async {
    _itemCount = 1;
    itemsCount = 1;
    imageSavePath = '';
    image = null;
    notifyListeners();
  }
}
