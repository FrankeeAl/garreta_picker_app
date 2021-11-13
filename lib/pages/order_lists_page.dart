import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import '../provider/orders_provider.dart';
import '../provider/customer_provider.dart';
import '../provider/merchant_provider.dart';

import '../widgets/order_item_widget.dart';

class OrderListsPage extends StatefulWidget {
  static const routeName = '/order-lists-page';

  const OrderListsPage({Key? key}) : super(key: key);

  @override
  _OrderListsPageState createState() => _OrderListsPageState();
}

class _OrderListsPageState extends State<OrderListsPage> {
  final key = GlobalKey<AnimatedListState>();
  String? merchantId;
  String? merchantName;

  var _isLoading = false;

  Future? _ordersFuture;

  Future? _obtainMerchantFuture() async {
    return await Provider.of<Merchants>(context, listen: false).fetchMerchant();
  }

  Future? _obtainOrderList() async {
    return await Provider.of<OrderList>(context, listen: false).fetchOrders();
  }

  @override
  initState() {
    _isLoading = true;
    if (mounted) {
      setState(() {
        _obtainMerchantFuture();
      });
    }
    _ordersFuture = _obtainOrderList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildOrderList(),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  Widget buildOrderList() {
    return FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              //Error handling code here.
              return const Center(child: Text("Oops something went wrong."));
            } else {
              return Consumer<OrderList>(
                builder: (ctx, data, child) => AnimatedList(
                  key: key,
                  //padding: const EdgeInsets.all(6),
                  shrinkWrap: true,
                  initialItemCount: data.orders.length,
                  itemBuilder: (ctx, index, animation) => buildItem(
                    data.orders[index],
                    index,
                    animation,
                  ),
                ),
              );
            }
          }
        });
  }

  Widget buildItem(items, int index, Animation<double> animation) {
    return OrderItemWidget(
      orders: items,
      index: index,
      animation: animation,
      onClicked: () => removeItem(index),
    );
  }

  void removeItem(int index) {
    final orderItem = Provider.of<OrderList>(context, listen: false).orders;
    final remove = orderItem.removeAt(index);

    key.currentState?.removeItem(
      index,
      (context, animation) => buildItem(remove, index, animation),
    );
    print('$index Removed...');
  }
}
