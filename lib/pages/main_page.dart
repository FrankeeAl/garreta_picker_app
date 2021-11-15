import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/merchant_provider.dart';

import '../pages/order_lists_page.dart';
import '../pages/completed_orders_page.dart';
import '../pages/products_page.dart';
import '../pages/home_page.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/home-page';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? title = "Garreta Picker";
  Future? _merchantsFuture;
  Future? _obtainMerchantFuture() async {
    return await Provider.of<Merchants>(context, listen: false).fetchMerchant();
  }

  int index = 0;
  final screens = const [
    HomePage(),
    OrderListsPage(),
    CompletedOrdersPage(),
    ProductsPage()
    //Navigator.pushReplacementNamed(context, ProductsPage.routeName),
  ];

  @override
  void initState() {
    _merchantsFuture = _obtainMerchantFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leadingWidth: 60,
        leading: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Image.asset(
              'assets/images/garreta_logo.png',
              fit: BoxFit.fitHeight,
              color: Theme.of(context).colorScheme.onPrimary,
            )),
        title: index == 0
            ? Text(title!, style: Theme.of(context).textTheme.headline2)
            : Consumer<Merchants>(
                builder: (context, merchantData, child) {
                  final name = merchantData.merchantName;
                  return name == null
                      ? const CircularProgressIndicator()
                      : Text(
                          name,
                          style: Theme.of(context).textTheme.headline2,
                        );
                },
              ),
      ),
      body: screens[index],
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Theme.of(context).colorScheme.secondary,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
              letterSpacing: 1.0,
              fontFamily: 'Quicksand',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedIndex: index,
          animationDuration: const Duration(seconds: 2),
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
              selectedIcon: Icon(Icons.home_outlined),
            ),
            NavigationDestination(
              icon: Icon(
                Icons.shopping_cart,
              ),
              label: 'Orders',
              selectedIcon: Icon(Icons.shopping_cart_outlined),
            ),
            NavigationDestination(
              icon: Icon(
                Icons.checklist,
              ),
              label: 'Completed',
              selectedIcon: Icon(Icons.checklist_outlined),
            ),
            NavigationDestination(
              icon: Icon(
                Icons.store_mall_directory,
              ),
              label: 'Products',
              selectedIcon: Icon(Icons.store_mall_directory_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
