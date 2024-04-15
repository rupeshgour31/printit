import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_appbar.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Poster/poster_model.dart';
import 'package:printit_app/Poster/poster_widgets.dart';
import 'package:provider/provider.dart';

class Rollup extends StatefulWidget {
  @override
  _RollupState createState() => _RollupState();
}

class _RollupState extends State<Rollup> {
  List<Map> rollupItems = [
    {
      'icon': 'assets/icons/paper_icon.png',
      'title': 'Rollup Size',
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
              'RollUp',
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
                          'assets/images/rollUp.png',
                          rollupItems,
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