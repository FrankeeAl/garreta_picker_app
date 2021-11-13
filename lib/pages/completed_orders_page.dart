import 'package:flutter/material.dart';

class CompletedOrdersPage extends StatefulWidget {
  static const routeName = '/completed-orders-page';

  const CompletedOrdersPage({Key? key}) : super(key: key);

  @override
  _CompletedOrdersPageState createState() => _CompletedOrdersPageState();
}

class _CompletedOrdersPageState extends State<CompletedOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Center(
          child: Text(
            'Completed Orders Page',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
    );
  }
}
