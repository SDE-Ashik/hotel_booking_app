import 'package:airbnb/components/custom_map_widget.dart';
import 'package:airbnb/components/display_place_widget.dart';
import 'package:airbnb/components/display_total_price_widget.dart';
import 'package:airbnb/components/searchandfilter_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExploreScrren extends StatefulWidget {
  const ExploreScrren({super.key});

  @override
  State<ExploreScrren> createState() => _ExploreScrrenState();
}

class _ExploreScrrenState extends State<ExploreScrren> {
  // collection for category
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection("appCategory");

  int selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SearchbarAndFilterWidget(),
          // fetch category from firebase
          
              listOfCategory(size),
              Expanded(child: SingleChildScrollView(child: Column(
                children: [
                    DisplayTotalPrice(),
                    SizedBox(
                      height: 10,
                    ),
                    DisplayPlaceWidget(),
                ],

              ),)),
            
            ],
          )),
          // for g
          floatingActionButton: CustomMapWidget(),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> listOfCategory(Size size) {
    return StreamBuilder(
        stream: categoryCollection.snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            return Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 100,
                  child: Divider(
                    color: Colors.black12,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.12,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: streamSnapshot.data!.docs.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectIndex = index;
                            });
                          },
                          child: Container(
                            padding:
                                EdgeInsets.only(top: 30, right: 20, left: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                Container(
                                  height: 32,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    streamSnapshot.data!.docs[index]['image'],
                                    color: selectIndex == index
                                        ? Colors.black
                                        : Colors.black45,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  streamSnapshot.data!.docs[index]['title'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: selectIndex == index
                                        ? Colors.black
                                        : Colors.black45,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 3,
                                    width: 50,
                                    color: streamSnapshot.data!.docs[index]
                                                ['image'] ==
                                            index
                                        ? Colors.black
                                        : Colors.transparent)
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
