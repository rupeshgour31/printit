import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Poster/poster_model.dart';
import 'package:printit_app/Poster/poster_widgets.dart';
import 'package:provider/provider.dart';

class Flyer extends StatefulWidget {
  @override
  _FlyerState createState() => _FlyerState();
}

class _FlyerState extends State<Flyer> {
  List<Map> flyerItems = [
    {
      'icon': 'assets/icons/paper_icon.png',
      'title': 'Paper Type',
    },
    {
      'icon': 'assets/icons/size_icon.png',
      'title': 'Paper Size',
    },
    {
      'icon': 'assets/icons/designIcon.png',
      'title': 'Printing Sides',
    },
    {
      'icon': 'assets/icons/design_icon.png',
      'title': 'Design',
    },
    {
      'icon': 'assets/icons/designIcon.png',
      'title': 'Number of Copies',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<PosterModel>(
      builder: (context, model, _) {
        return MediaQuery(
          data: mediaText(context),
          child: Scaffold(
            appBar: commonAppbar(
              'Poster',
              context,
              IconButton(
                icon: Icon(
                  Icons.save_outlined,
                  color: whiteColor,
                  size: 25.0,
                ),
                onPressed: null,
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
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Column(
                      children: [
                        commonTypesShow(
                          context,
                          model,
                          'assets/images/flyerimg.png',
                          flyerItems,
                        ),
                      ],
                    ),
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
