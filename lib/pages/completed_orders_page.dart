import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:garreta_picker_app/models/completed.dart';

class CompletedOrdersPage extends StatefulWidget {
  static const routeName = '/completed-orders-page';

  const CompletedOrdersPage({Key? key}) : super(key: key);

  @override
  _CompletedOrdersPageState createState() => _CompletedOrdersPageState();
}

final _database = FirebaseDatabase.instance.reference();

class _CompletedOrdersPageState extends State<CompletedOrdersPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              'Completed Orders Page',
              style: Theme.of(context).textTheme.headline2,
            ),
            buildStream(size),
          ],
        ),
      ),
    );
  }

  Widget buildStream(Size size) {
    return StreamBuilder(
      stream: _database.child('completedOrders').limitToLast(10).onValue,
      builder: (context, snapshot) {
        final tileList = <ListTile>[];
        if (snapshot.hasData) {
          final completed = Map<String, dynamic>.from(
              (snapshot.data! as Event).snapshot.value);
          final complete = CompletedOrders.fromRTDB(completed);
          final completedTile = ListTile(
            leading: Image.asset(
              complete.custName,
              fit: BoxFit.cover,
            ),
            title: Text(
              complete.custContactNumber,
            ),
            subtitle: Column(
              children: <Widget>[
                Text(
                  complete.amount.toString(),
                ),
                Text(
                  complete.dateTime.toString(),
                )
              ],
            ),
          );
          tileList.add(completedTile);
        }
        return Expanded(
          child: SizedBox(
            height: size.height * .5,
            child: ListView(
              children: tileList,
            ),
          ),
        );
      },
    );
  }
}
