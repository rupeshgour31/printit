import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:printit_app/Api/Request/WSNotesListAndCategRequest.dart';
import 'package:printit_app/Api/api_manager_Form.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Common/my_text_field.dart';
import 'package:printit_app/Notes/NotesList/notes_list_widgets.dart';

class NotesList extends StatefulWidget {
  static const routeName = '/notes_list';

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  List notesData = [];
  List notesCategory = [];
  List notesArray = [
    {
      'id': '#10202',
      'author': 'salman ahmad',
      'name': 'Demo Project Name',
      'price': '250',
      'image': 'https://picsum.photos/250?image=9',
    },
    {
      'id': '#10200',
      'author': 'amar deewan',
      'name': 'Demo 1',
      'price': '250',
      'image': 'https://picsum.photos/250?image=9',
    },
    {
      'id': '#10204',
      'author': 'shahbaj khan',
      'name': 'Demo 2',
      'price': '250',
      'image': 'https://picsum.photos/250?image=9',
    },
    {
      'id': '#10208',
      'author': 'arshad mansoori',
      'name': 'Demo 3',
      'price': '250',
      'image': 'https://picsum.photos/250?image=9',
    },
    {
      'id': '#10302',
      'author': 'ashim mansoori',
      'name': 'Demo 4',
      'price': '250',
      'image': 'https://picsum.photos/250?image=9',
    },
    {
      'id': '#10222',
      'author': 'shahrukh shekh',
      'name': 'Demo 5',
      'price': '250',
      'image': 'https://picsum.photos/250?image=9',
    },
  ];
  @override
  void initState() {
    super.initState();
    getNotesListAntCateg();
  }

  @override
  void getNotesListAntCateg() async {
    var otpRequest = WSNotesListAndCategRequest(
      endPoint: APIManagerForm.endpoint,
    );
    await APIManagerForm.performRequest(otpRequest, showLog: true);

    try {
      Map dataResponse = otpRequest.response;
      print(dataResponse);
      setState(
        () {
          notesData = dataResponse['notes'];
          notesCategory = dataResponse['notes_cat'];
          for (Map data in dataResponse['notes']) {
            // _notesDetails.add(
            //   NotesDetails.fromJson(data),
            // );
          }
        },
      );
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  TextEditingController searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = [];
      tabs.add( Tab(
        child: Container(
          padding: EdgeInsets.only(
            left: 12,
            right: 12.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Color(0xff1C719C),
            ),
          ),
          child: Center(
            child: Text(
              "All Classes",
            ),
          ),
        ),
      ));
      for (var i = 0; i < notesCategory.length; i++) {
        tabs.add(
            Tab(
              child: Container(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Color(0xff1C719C),
                  ),
                ),
                child: Center(
                  child: Text(
                    notesCategory[i]['name'] ?? "",
                  ),
                ),
              ),
            )
        );
      };
      return DefaultTabController(
      length: (notesCategory.length == 0)? 0 : notesCategory.length + 1,
      initialIndex: 1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(155),
          child: Stack(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/img1.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.black45,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 55.0,
                      left: 20.0,
                      right: 20.0,
                      bottom: 60.0,
                    ),
                    height: 50.0,
                    padding: EdgeInsets.only(left: 0.0, right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      color: Colors.black38,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.transparent,
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back_outlined,
                            color: whiteColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                        // Icon(Icons.search),
                        title: TextField(
                          controller: searchController,
                          cursorColor: whiteColor,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 16.0,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            prefixStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              color: whiteColor,
                              fontSize: 16.0,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: whiteColor,
                              ),
                              onPressed: null,
                            ),
                          ),
                          onChanged: onSearchTextChanged,
                        ),
                      ),
                    ),
                  ),
                ),
    /*bottom: notesCategory.length == 0
                    ? MyLinearProgressIndicator(
                        backgroundColor: Colors.orange,
                      )*/
                    /*: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Color(0xff549584),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: whiteColor,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xff1C719C),
                        ),
                        tabs: tabs,
                      ),*/
              ),
            ],
          ),
        ),
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
          child: TabBarView(
            children: List<Widget>.generate((notesCategory.length == 0)? 0 : notesCategory.length + 1, (int index){

              if (index == 0) {
                return notsListView(
                  notesData,
                  context,
                  _searchResult,
                  searchController,
                );
              }
              else {
                var categoryID = notesCategory[index -1]['id'];
                var notesDataFiltered = notesData.where((note) => note['category'] == categoryID).toList();
                return notsListView(
                  notesDataFiltered,
                  context,
                  _searchResult,
                  searchController,
                );
              }



            }),
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _notesDetails.forEach(
      (notesDetails) {
        if (notesDetails.name.contains(text)) {
          _searchResult.add(notesDetails);
        }
      },
    );

    setState(() {});
  }
}

List<NotesDetails> _searchResult = [];

List<NotesDetails> _notesDetails = [];

class NotesDetails {
  final String id;
  final String name;
  final String image;
  final String description;

  NotesDetails({
    required  this.id,
    required  this.name,
    required this.image,
    required this.description,
  });

  factory NotesDetails.fromJson(Map<String, dynamic> json) {
    return new NotesDetails(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
    );
  }
}

const double _kMyLinearProgressIndicatorHeight = 6.0;

// class MyLinearProgressIndicator extends LinearProgressIndicator
//     implements PreferredSizeWidget {
//   MyLinearProgressIndicator({
//     Key? key,
//     double? value,
//     Color? backgroundColor,
//     Animation<Color>? valueColor,
//   }) : super(
//           key: key,
//           value: value,
//           backgroundColor: backgroundColor,
//           valueColor: valueColor,
//         ) {
//     preferredSize = Size(double.infinity, _kMyLinearProgressIndicatorHeight);
//   }
//
//   @override
//   Size preferredSize;
// }
