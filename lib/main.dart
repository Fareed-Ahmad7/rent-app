import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rent_app/pages/shop_details.dart';
import 'package:rent_app/model/shop_model.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<List<Shop>> readShopDetails() => FirebaseFirestore.instance
        .collection('visanka_complex')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Shop.fromJson(doc.data())).toList());

    Widget buildShopsList(Shop shop) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
                title: Text(shop.ShopName),
                subtitle: Text(shop.TenantName),
                trailing: Text((shop.RentBalance).toString()),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShopDetails(
                                shop_details: shop,
                              )));
                }),
          ),
        );

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Visanka Complex',
            style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 32),
          ),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<List<Shop>>(
            stream: readShopDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final shops = snapshot.data!;
                return ListView(
                  shrinkWrap: true,
                  children: shops.map(buildShopsList).toList(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
