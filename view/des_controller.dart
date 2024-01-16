import 'package:cloud_firestore/cloud_firestore.dart';

class AlleventsController {
  Stream<QuerySnapshot> getAlleventsStream() {
    return FirebaseFirestore.instance.collection('categories').snapshots();
  }

  final CollectionReference favoritesCollection =
  FirebaseFirestore.instance.collection('user_favorites');

  Future<void> addToFavorites(String categoryId, String itemId) async {
    try {
      // Fetch the item from the 'categories' collection
      DocumentSnapshot categorySnapshot =
      await FirebaseFirestore.instance.collection('categories').doc(categoryId).get();

      if (categorySnapshot.exists) {
        // Extract the item details from the category
        Map<String, dynamic> itemData = categorySnapshot.data() as Map<String, dynamic>;

        // Create a new document in 'user_favorites' with the item details
        await favoritesCollection.doc(itemId).set(itemData);
        print('Item added to favorites successfully!');
      } else {
        print('Category or item not found!');
      }
    } catch (error) {
      print('Error adding item to favorites: $error');
    }
  }

  Stream<QuerySnapshot> getFavoritesStream(String userId) {
    // Return a stream of the user's favorite items
    return favoritesCollection.where('userId', isEqualTo: userId).snapshots();
  }

  Future<void> removeFromFavorites(String userId, String itemId) async {
    try {
      // Remove the item from the 'user_favorites' collection
      await favoritesCollection.doc(itemId).delete();
      print('Item removed from favorites successfully!');
    } catch (error) {
      print('Error removing item from favorites: $error');
    }
  }
}
