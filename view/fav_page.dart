import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'des_controller.dart';

class FavoritesPage extends StatefulWidget {
  final User user;

  const FavoritesPage({Key? key, required this.user}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final AlleventsController _alleventsController = AlleventsController();
  late Stream<QuerySnapshot> _favoritesStream;

  @override
  void initState() {
    super.initState();

    // Listen for changes in the user's favorite items
    _favoritesStream = _alleventsController.getFavoritesStream(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _favoritesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No favorite items.'),
            );
          }

          // Build a list of favorite items
          List<Widget> favoriteItemsList = snapshot.data!.docs.map((doc) {
            // Access your favorite item data here
            String itemName = doc['itemName'];

            return ListTile(
              title: Text(itemName),
              // Add other UI components as needed
            );
          }).toList();

          return ListView(
            children: favoriteItemsList,
          );
        },
      ),
    );
  }
}
