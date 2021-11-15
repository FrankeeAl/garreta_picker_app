import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:garreta_picker_app/models/order_stream.dart';

import '../models/completed.dart';

class CompletedOrdersPage extends StatefulWidget {
  static const routeName = '/completed-orders-page';

  const CompletedOrdersPage({Key? key}) : super(key: key);

  @override
  _CompletedOrdersPageState createState() => _CompletedOrdersPageState();
}

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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: size.width,
            child: Expanded(
              child: Column(
                children: [
                  Text(
                    'Completed Orders',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  buildStream(size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStream(Size size) {
    return StreamBuilder(
      stream: OrderStream().getOrderStream(),
      builder: (context, snapshot) {
        final tileList = <ListTile>[];
        if (snapshot.hasData) {
          final completed = snapshot.data as List<CompletedOrders>;

          tileList.addAll(completed.map((completedOrder) {
            return ListTile(
              leading: const Icon(
                Icons.check_box_outline_blank_outlined,
                size: 30,
              ),
              title: Text(
                completedOrder.custName,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                completedOrder.custContactNumber,
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Text(
                completedOrder.amount.toString(),
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          }));
        } else {
          return const CircularProgressIndicator();
        }
        return Expanded(
          child: ListView(
            children: tileList,
          ),
        );
      },
    );
  }
}
