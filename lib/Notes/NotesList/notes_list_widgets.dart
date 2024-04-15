import 'package:flutter/material.dart';
import 'package:printit_app/Common/common_widgets.dart';
import 'package:printit_app/Notes/NotsView/notes_view.dart';

Widget notsListView(
  notesList,
  context,
  _searchResult,
  searchController,
) {
  print('notes list get rupesh ${_searchResult}');
  print('notes list get rupesh ${searchController.text}');
  return Container(
    height: MediaQuery.of(context).size.height * 0.85,
    child: _searchResult.length != 0 || searchController.text.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _searchResult.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesView(
                        notes_id: _searchResult[index].id,
                      ),
                    ),
                  );
                  searchController.clear();
                },
                child: Container(
                  padding: EdgeInsets.only(right: 10.0),
                  margin: EdgeInsets.all(8.0),
                  width: 180.0,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: Image.network(
                            _searchResult[index].image,
                          ),
                        ),
                      ),
                      widthSizedBox(12.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _searchResult[index].name ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Nunito',
                            ),
                            maxLines: 2,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.48,
                            child: Text(
                              _searchResult[index].description ?? '',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Nunito',
                              ),
                              maxLines: 3,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ),
              );
            },
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: notesList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesView(
                        notes_id: notesList[index]['id'],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(right: 10.0),
                  margin: EdgeInsets.all(8.0),
                  width: 180.0,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: Image.network(
                            notesList[index]['image'],
                          ),
                        ),
                      ),
                      widthSizedBox(12.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notesList[index]['name'] ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Nunito',
                            ),
                            maxLines: 2,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.48,
                            child: Text(
                              notesList[index]['description'] ?? '',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Nunito',
                              ),
                              maxLines: 3,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}
