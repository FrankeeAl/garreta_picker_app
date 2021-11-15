import 'package:flutter/material.dart';

import '../models/completed.dart';
import '../models/order_stream.dart';

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
            height: 300,
            width: size.width,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Completed Orders',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                buildStream(size),
              ],
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
                Icons.check_box_outlined,
                size: 30,
              ),
              title: Text(
                completedOrder.custName,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                completedOrder.custContactNumber,
                style: Theme.of(context).textTheme.headline5,
              ),
              trailing: Text(
                completedOrder.amount.toString(),
                style: Theme.of(context).textTheme.headline6,
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
