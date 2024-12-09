import 'package:airbnb/view/place_detailed_page.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayPlaceWidget extends StatefulWidget {
  const DisplayPlaceWidget({super.key});

  @override
  State<DisplayPlaceWidget> createState() => _DisplayPlaceWidgetState();
}

class _DisplayPlaceWidgetState extends State<DisplayPlaceWidget> {
  // collection for place
  final CollectionReference placeCollection =
      FirebaseFirestore.instance.collection("myAppCollection");
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: placeCollection.snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: streamSnapshot.data!.docs.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 15,
                  );
                },
                itemBuilder: (context, index) {
                  final place = streamSnapshot.data!.docs[index];
                  var price = place['price'].toString();
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    PlaceDetailedScreen(place: place),),);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox(
                                  height: 370,
                                  width: double.infinity,
                                  child: AnotherCarousel(
                                    images: place['imageUrls']
                                        .map((url) => NetworkImage(url))
                                        .toList(),
                                    dotSize: 6,
                                    indicatorBgPadding: 5,
                                    dotColor: Colors.transparent,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 25,
                                left: 15,
                                right: 15,
                                child: Row(
                                  children: [
                                    place['isActive'] == true
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 15),
                                              child: Text(
                                                "Guest Favorite",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                          ),
                                    Spacer(),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.favorite_outline_rounded,
                                          size: 34,
                                          color: Colors.white,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Icon(
                                            Icons.favorite,
                                            size: 30,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              vendorProfile(place)
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            children: [
                              Text(
                                place['address'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(place['rating'].toString()),
                            ],
                          ),
                          Text(
                            "Stay with ${place['vendor']} . ${place['vendorProfession']}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16.5,
                            ),
                          ),
                          Text(
                            place['date'],
                            style: const TextStyle(
                                fontSize: 16.5, color: Colors.black54),
                          ),
                          SizedBox(
                            height: size.height * 0.007,
                          ),
                          RichText(
                            text: TextSpan(
                                text: "\₹ ${place['price']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                children: const [
                                  TextSpan(
                                    text: " night",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Positioned vendorProfile(QueryDocumentSnapshot<Object?> place) {
    return Positioned(
        bottom: 25,
        left: 10,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: Image.asset(
                "Assest/images/book_cover.png",
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  place['vendorProfile'],
                ),
              ),
            )
          ],
        ));
  }
}
