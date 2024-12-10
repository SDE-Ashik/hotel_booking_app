import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<String> get favorite => _favoriteIds;
  FavoriteProvider() {
    loadFavourite();
  }
  void toggleFavorite(DocumentSnapshot place) async {
    String placeId = place.id;
    if (_favoriteIds.contains(placeId)) {
      _favoriteIds.remove(placeId);
      await _removeFavorite(placeId);
    } else {
      _favoriteIds.add(placeId);
      await _addFavorites(placeId);
    }
    notifyListeners();
  }

//  check if a place is  a favorized
  bool isExist(DocumentSnapshot place) {
    return _favoriteIds.contains(place.id);
  }

  // add  favourites  items  to  firestoire
  Future<void> _addFavorites(String placeId) async {
    try {
      // create the userFavourite collection and add items as favouite
      await firebaseFirestore
          .collection("userFavourite")
          .doc(placeId)
          .set({'isFavourie': true});
    } catch (e) {
      print(e.toString());
    }
  }

  // remove favourite items from fire store
  Future<void> _removeFavorite(String placeId) async {
    try {
      // create the userFavourite collection and add items as favouite
      await firebaseFirestore.collection("userFavourite").doc(placeId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //  load favourite items  from firebase  if( user make some items favourite  then load )
  Future<void> loadFavourite() async {
    try {
      QuerySnapshot snapshot =
          await firebaseFirestore.collection("userFavourite").get();
      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
  // static method to access  the provider from any context

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of(context, listen: listen);
  }
}
