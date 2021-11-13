import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebasePlayground extends StatefulWidget {
  const FirebasePlayground({Key? key}) : super(key: key);

  @override
  _FirebasePlaygroundState createState() => _FirebasePlaygroundState();
}

class _FirebasePlaygroundState extends State<FirebasePlayground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('merchants/F0QzUGgxswinlh74pbNJ/name')
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView();
      },
    ));
  }
}
