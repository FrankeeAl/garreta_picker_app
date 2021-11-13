import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import '../provider/merchant_provider.dart';
import '../provider/customer_provider.dart';
import '../provider/categories_provider.dart';
import '../provider/shelves_provider.dart';
import '../provider/orders_provider.dart';

import '../widgets/order_detail_widget.dart';
import '../widgets/order_item_widget.dart';

import '../pages/main_page.dart';
import '../pages/signin_page.dart';
import '../pages/order_lists_page.dart';
import '../pages/products_page.dart';

import '../models/auth.dart';
import '../models/racks.dart';
import '../models/shelf.dart';
import '../unused/splash_screen.dart';
import '../provider/product_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String title = "Garreta Picker";
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Merchants?>(
          create: (_) => null,
          update: (ctx, auth, merchant) => Merchants(
            auth.token,
            auth.userId,
          ),
          child: const OrderListsPage(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList?>(
          create: (_) => null,
          update: (ctx, auth, orders) => OrderList(
            auth.token,
            auth.userId,
            orders == null ? [] : orders.orders,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Shelves(),
          child: const OrderDetailWidget(),
        ),
        // ChangeNotifierProvider<Products>(
        //   create: (ctx) => Products(),
        //   child: const OrderDetailWidget(),
        // ),
        ChangeNotifierProvider(
          create: (ctx) => Racks(),
          child: const OrderDetailWidget(),
        ),
        ChangeNotifierProxyProvider<Auth, Products?>(
          create: (_) => null,
          update: (ctx, auth, itemList) => Products(
            auth.token,
            auth.userId,
            itemList == null ? [] : itemList.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Categories(),
          child: const ProductsPage(),
        ),
        ChangeNotifierProxyProvider<Auth, CustomerDetail?>(
          create: (_) => null,
          update: (ctx, auth, previousDetails) => CustomerDetail(
            auth.token,
            auth.userId,
            previousDetails == null ? [] : previousDetails.details,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: title,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              onSecondary: Color.fromRGBO(46, 139, 192, 1),
              onPrimary: Color.fromRGBO(12, 45, 72, 1),
              primaryVariant: Color.fromRGBO(20, 93, 160, 1),
              secondary: Color.fromRGBO(177, 212, 224, 1),
              primary: Color.fromRGBO(106, 164, 176, 10),
              secondaryVariant: Color.fromRGBO(225, 231, 224, 10),
              background: Color.fromRGBO(177, 212, 224, 1),
            ),
            //   primaryColorLight: const Color.fromRGBO(225, 231, 224, 10),
            textTheme: const TextTheme(
              headline1: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 35,
                  color: Color.fromRGBO(12, 45, 72, 1),
                  fontWeight: FontWeight.bold),
              headline2: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(12, 45, 72, 1),
              ),
              headline3: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  color: Color.fromRGBO(12, 45, 72, 1),
                  fontWeight: FontWeight.bold),
              headline4: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(12, 45, 72, 1),
              ),
              headline5: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 12,
                  color: Color.fromRGBO(46, 139, 192, 1),
                  fontWeight: FontWeight.bold),
              headline6: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 13,
                  color: Color.fromRGBO(12, 45, 72, 1),
                  fontWeight: FontWeight.bold),
              bodyText1: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(12, 45, 72, 1),
              ),
              bodyText2: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(12, 45, 72, 1),
              ),
            ),
          ),
          home: auth.isAuth
              ? const MainPage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const SignInPage(),
                ),
          routes: {
            SignInPage.routeName: (ctx) => const SignInPage(),
            MainPage.routeName: (ctx) => const MainPage(),
            OrderListsPage.routeName: (ctx) => const OrderListsPage(),
            ProductsPage.routeName: (ctx) => const ProductsPage(),
            OrderDetailWidget.routeName: (ctx) => const OrderDetailWidget(),
          },
        ),
      ),
    );
  }
}
