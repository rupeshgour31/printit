import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Design/design_widgets.dart';
import 'package:printit_app/Poster/poster_model.dart';
import 'package:provider/provider.dart';


class Design extends StatefulWidget {
  @override
  _DesignState createState() => _DesignState();
}

class _DesignState extends State<Design> {
  @override
  Widget build(BuildContext context) {
    final  designDetail = ModalRoute.of(context)!.settings.arguments;
    var printType = 'Quick Print';//designDetail["currentPrintType"];
    print("Bhumit $printType");
    var shouldShowCamera = false;
    var isGalleryPicker = true;
    var isBanner = false;

    if (printType == "Translate" || printType == 'ترجمة' || printType == "Quick Print" ||
        printType == 'طباعة سريعة') {
      shouldShowCamera = true;
      isGalleryPicker = false;
    }

    if (printType == "Banner" || printType == 'بانير' ) {
      isBanner = true;
    }

    return Consumer<PosterModel>(
      builder: (context, model, _) {
        return MediaQuery(
          data: mediaText(context),
          child: Scaffold(
            appBar: commonAppbar(
              'Design',
              context,
              IconButton(
                onPressed: () {
                  model.designUpload(context, designDetail);
                },
                icon: Icon(
                  Icons.check,
                  color: whiteColor,
                ),
              ),
            ),
            extendBodyBehindAppBar: true,
            body: Container(
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
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    children: [
                      cameraUploadBtnAndSizeText(model, context, shouldShowCamera, isGalleryPicker),
                      heightSizedBox(30.0),
                      imageContainer(model, context, isBanner, isGalleryPicker),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
