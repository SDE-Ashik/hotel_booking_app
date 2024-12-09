import 'package:airbnb/components/myicon_button_widget.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMapWidget extends StatefulWidget {
  const CustomMapWidget({super.key});

  @override
  State<CustomMapWidget> createState() => _CustomMapWidgetState();
}

class _CustomMapWidgetState extends State<CustomMapWidget> {
  LatLng myCurrentLocation = const LatLng(9.9312, 76.2673);
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  late GoogleMapController googleMapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final CollectionReference placeCollection =
      FirebaseFirestore.instance.collection("myAppCollection");
  List<Marker> markers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMarker();
  }

//
  // for custom maker
  Future<void> _loadMarker() async {
    customIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(), "Assest/images/marker.png",
        height: 30, width: 30);
    Size size = MediaQuery.of(context).size;
    placeCollection.snapshots().listen((QuerySnapshot streamSnapshoot) {
      if (streamSnapshoot.docs.isNotEmpty) {
        final List allMarks = streamSnapshoot.docs;
        List<Marker> myMarker = [];
        for (final marker in allMarks) {
          final dat = marker.data();
          final data = (dat) as Map;
          myMarker.add(
            Marker(
                markerId: MarkerId(
                  data['address'],
                ),
                position: LatLng(data['latitude'], data['longitude']),
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                    Container(
                      height: size.height * 0.5,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: size.height * 0.203,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                  child: AnotherCarousel(
                                    images: data['imageUrls']
                                        .map((url) => NetworkImage(url))
                                        .toList(),
                                    dotSize: 5,
                                    indicatorBgPadding: 5,
                                    dotBgColor: Colors.transparent,
                                  ),
                                ),
                              ),
                              Positioned(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Text(
                                      "Guest Favorite",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                               const    Spacer(),
                                  MyiconButtonWidget(
                                    icon: Icons.favorite_border,
                                    radius: 15,
                                  ),
                               const  SizedBox(
                                    width: 13,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _customInfoWindowController
                                          .hideInfoWindow!();
                                    },
                                    child: MyiconButtonWidget(icon: Icons.close,radius: 15,),
                                  )
                                ],
                              ))
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                          child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Row(
                              children: [
                                Text(data['address'],
                                style:const  TextStyle(fontSize: 16,
                                fontWeight: FontWeight.bold),),
                                 const Spacer(),
                                 const Icon(Icons.star),
                                 const SizedBox(width: 5,),
                                 Text(data['rating'].toString(),),
                                 
                              ],
                            ),
                            Text("3066 m elevation", style: TextStyle(fontSize: 16,
                            color: Colors.black45),),
                            Text(data['date'],style: TextStyle(fontSize: 16,
                            color: Colors.black54),),
                            Text.rich(TextSpan(text: "\$${data['price']}",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                            children: [
                              TextSpan(text: "night",style: TextStyle(fontWeight:FontWeight.normal ))
                            ]
                            ),),
                            ],
                          ),),
                         
                        ],
                      ),
                    ),
                    LatLng(data['latitude'], data['longitude']),
                  );
                },
                icon: customIcon),
          );
        }
        setState(() {
          markers = myMarker;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          // if click map show bottom sheet and show google map
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              clipBehavior: Clip.none,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: size.height * 0.77,
                  color: Colors.white,
                  width: size.width,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: size.height * 0.77,
                        child: GoogleMap(
                          initialCameraPosition:
                              CameraPosition(target: myCurrentLocation),
                          onMapCreated: (GoogleMapController controller) {
                            googleMapController = controller;
                            _customInfoWindowController.googleMapController =
                                controller;
                          },
                          onTap: (argument) {},
                          onCameraMove: (position) {
                            _customInfoWindowController.onCameraMove!();
                          },
                          markers: markers.toSet(),
                        ),
                      ),
                      CustomInfoWindow(
                        controller: _customInfoWindowController,
                        height: size.height * 0.3,
                        width: size.width * 0.85,
                        offset: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 170, vertical: 5),
                          child: Container(
                            height: 5,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        label: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Text(
                "Map",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.map_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ));
  }
}

// AIzaSyCu43f87sjCNdrXMZD4-97dtfvtOtviKz4
