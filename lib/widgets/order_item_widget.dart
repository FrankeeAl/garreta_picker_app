import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:garreta_picker_app/provider/categories_provider.dart';

import '../models/orders.dart' as ord;
import '../models/customer.dart';
import '../widgets/order_detail_widget.dart';

class OrderItemWidget extends StatefulWidget {
  final ord.Order orders;
  final int index;
  final Animation<double> animation;
  final VoidCallback onClicked;

  const OrderItemWidget({
    Key? key,
    required this.orders,
    required this.index,
    required this.animation,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _tapped = false;
  Customer? _customer;
  final _database = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    setState(() {
      _tapped = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
        child: ListTile(
          hoverColor: Theme.of(context).colorScheme.primaryVariant,
          selected: false,
          isThreeLine: false,
          leading: IconButton(
            icon: Icon(
              Icons.pending_actions,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            iconSize: 20,
            onPressed: () {},
          ),

          // CircleAvatar(
          //   radius: 32,
          //   backgroundColor: Theme.of(context).colorScheme.secondary,
          //   backgroundImage: const AssetImage(
          //     'assets/images/garreta_logo.png',
          //   ),
          // ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.orders.name!,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                widget.orders.number!,
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount: ₱' + widget.orders.amount.toString(),
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                'Item Count: ' + widget.orders.products!.length.toString(),
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          onTap: () {
            Categories();
            Navigator.of(context).pushNamed(
              OrderDetailWidget.routeName,
              arguments: widget.orders,
            );
          },
          trailing: IconButton(
            iconSize: 20,
            icon: _tapped
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                : Icon(Icons.check_circle_outline,
                    color: Theme.of(context).colorScheme.primary),
            onPressed: () {},
            //widget.onClicked

            // setState(() {
            //   _tapped = !_tapped;
            // });
          ),
        ),
      ),
    );
  }
}
