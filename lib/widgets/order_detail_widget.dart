import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/orders.dart';
import '../models/customer.dart';
import '../models/racks.dart';
import '../models/shelf.dart';
import '../models/product.dart';

import '../provider/product_provider.dart';
import '../provider/shelves_provider.dart';
import '../pages/order_lists_page.dart';
import '../pages/main_page.dart';

import '../provider/customer_provider.dart';
import '../provider/categories_provider.dart';

class OrderDetailWidget extends StatefulWidget {
  const OrderDetailWidget({Key? key}) : super(key: key);
  static const routeName = "/order-detail";

  @override
  State<OrderDetailWidget> createState() => _OrderDetailWidgetState();
}

class _OrderDetailWidgetState extends State<OrderDetailWidget> {
  int pageIndex = 1;
  final _database = FirebaseDatabase.instance.reference();
  static const ordersPath = 'orders/';
  static const productsPath = 'products/';
  static const completedPath = 'completedOrders';
  static const racks = 'Product Racks';
  static const qtyLabel = 'Quantity';

  Customer? customerDetails;
  Order? orderData;
  Future? _getTopsFuture;
  Future? _getBottomsFuture;
  Future? _getHatsFuture;
  Future? _getRacksFuture;

  String qrCode = 'code';
  bool _isDone = false;
  List<bool> _isMatch = [];
  Product? _loadedProducts;
  List<Product>? _updatedProducts = [];

  int qtyOnhand = 0;
  int newQtyOnHand = 0;
  int newOrderLevel = 0;
  int selectedIndex = 0;
  List<bool> isSelected = [];
  Product? updateProduct;

  Future? _obtainTopsData() async {
    return await Provider.of<Shelves>(context, listen: false)
        .getTopsShelf()
        .then((value) => setState(() {}));
  }

  Future? _obtainBottomsData() async {
    return await Provider.of<Shelves>(context, listen: false)
        .getBottomsShelf()
        .then((value) => setState(() {}));
  }

  Future? _obtainHatsData() async {
    return await Provider.of<Shelves>(context, listen: false)
        .getHatsShelf()
        .then((value) => setState(() {}));
  }

  Future? _obtainRacksData() async {
    return await Provider.of<Racks>(context, listen: false)
        .getRacks()
        .then((value) => setState(() {}));
  }

  Future? _loadProducts() async {
    return await Provider.of<Products>(context, listen: false)
        .fetchProducts()
        .then((value) => setState(() {}));
  }

  @override
  void initState() {
    if (mounted) {
      setState(() {});
    }
    _getTopsFuture = _obtainTopsData();
    _getBottomsFuture = _obtainBottomsData();
    _getHatsFuture = _obtainHatsData();
    _getRacksFuture = _obtainRacksData();
    _loadProducts();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isMatch.clear();
    isSelected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    orderData = ModalRoute.of(context)?.settings.arguments as Order;
    _isSelected();

    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 60,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(MainPage.routeName),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Image.asset(
                'assets/images/garreta_logo.png',
                fit: BoxFit.fitHeight,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          centerTitle: false,
          title: Text(
            orderData!.name!,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                racks,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            SizedBox(
              height: size.height * .2,
              child: buildCategoryScroller(size),
            ),
            SizedBox(
              height: size.height * .5,
              child: buildOrderedProducts(size),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _isDone
                    ? () {
                        updateOrder();
                        completedOrders(orderData!);
                        removeOrder(orderData!.orderId!);
                      }
                    : null,
                child: const Text('Confirm Order Completion'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryScroller(Size size) {
    final rackData = Provider.of<Racks>(context, listen: false).racks;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) => Column(
        children: [
          SizedBox(
            width: size.width * .45,
            //  color: Theme.of(context).colorScheme.secondaryVariant,
            child: Consumer<Racks>(builder: (context, model, child) {
              if (model.racks != null) {
                return Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CachedNetworkImage(
                                imageUrl: 'https://bit.ly/3n37ILG',
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          child: Container(
                            width: size.width * .5,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20)),
                                color: Colors.white60),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Text(
                                  //shelvesData![index].code!,
                                  model.racks![index].title!,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                                Text(
                                  //shelvesData[index].items!,
                                  'Rack Order: ${model.racks![index].order.toString()}',
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
          ),
        ],
      ),
      separatorBuilder: (ctx, _) => const SizedBox(width: 6),
      itemCount: rackData!.length,
    );
  }

  Widget buildOrderedProducts(Size size) {
    List<Product>? loadedProducts = [];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (ctx, index) {
        return Consumer<Products>(builder: (context, model, child) {
          final productData = Provider.of<Products>(context, listen: false)
              .findById(orderData!.products![index].id!);
          loadedProducts = productData;

          return ListTile(
            isThreeLine: true,
            leading: SizedBox(
              height: 50,
              width: 50,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, i) {
                  return CachedNetworkImage(
                    imageUrl: productData[i].imageUrl!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                },
                itemCount: productData.length,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(orderData!.products![index].title!,
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
            subtitle: loadedProducts!.isEmpty
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(loadedProducts![0].rack!,
                          style: Theme.of(context).textTheme.headline6),
                      Text(' Shelf: ${loadedProducts![0].shelf!}',
                          style: Theme.of(context).textTheme.headline6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              Text('Qty: ',
                                  style: Theme.of(context).textTheme.headline5),
                              Text(
                                orderData!.products![index].quantity.toString(),
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ],
                          ),
                          Text(
                            orderData!.products![index].price.toString(),
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ],
                  ),
            trailing: _isMatch.elementAt(index)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Scanned',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Icon(
                        Icons.qr_code_scanner_outlined,
                        color: Theme.of(context).errorColor,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Scan',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      InkWell(
                          child: Image.asset(
                            'assets/images/qr_scan.png',
                            height: 30,
                            width: 30,
                          ),
                          onTap: () {
                            scanQRCode(
                              productData,
                              productData[0].barcode!,
                              orderData!.products![index].quantity,
                              productData[0].qtyOnHand!,
                              productData[0].reOrderLevel!,
                              index,
                              productData[0].id!,
                            );
                          }),
                    ],
                  ),
            selected: _isMatch[index],
          );
        });
      },
      itemCount: orderData!.products!.length,
    );
  }

  void _isSelected() {
    for (var i = 0; i < orderData!.products!.length; i++) {
      _isMatch.add(false);
    }
  }

  int _newQtyOnHand(
    List<Product>? products,
    int currentQtyOnhand,
    int orderedQtyOnhand,
    int index,
    String prodId,
  ) {
    var newQtyOnHand = currentQtyOnhand - orderedQtyOnhand;
    this.newQtyOnHand = newQtyOnHand;

    _database
        .child(productsPath + orderData!.products![index].id!)
        .update({'qtyOnHand': this.newQtyOnHand})
        .then(
          (value) => print('Updated successfully'),
        )
        .catchError(
          (onError) => print('Something happened.'),
        );

    // print('${newQtyOnHand.toString()} is the new quantity onhand.');
    // _showOkayDialog('$currentQtyOnhand + $orderedQtyOnhand new qty onhand...');
    return this.newQtyOnHand;
  }

  int _newOrderLevel(
    List<Product>? products,
    int currentOrderLevel,
    int recentOrderLevel,
    int index,
  ) {
    var newOrderLevel = currentOrderLevel + recentOrderLevel;
    this.newOrderLevel = newOrderLevel;

    _database
        .child(productsPath + orderData!.products![index].id!)
        .update({'reOrderLevel': this.newOrderLevel})
        .then(
          (value) => print('Updated successfully'),
        )
        .catchError(
          (onError) => print('Something happened.'),
        );
    // print('${this.newOrderLevel.toString()} is the loaded order level.');
    // _showOkayDialog(
    //     ' $currentOrderLevel + $recentOrderLevel   new order level...');
    return this.newOrderLevel;
  }

  // void _updateProduct(String id, Product newProduct) {
  //   final prodIndex =
  //       _loadedProducts!.indexWhere((element) => element.id == id);
  //   if (prodIndex >= 0) {
  //     _updatedProducts![prodIndex] = newProduct;
  //   } else {
  //     _showErrorDialog('Failed to update product');
  //   }
  // }

  Future<void> scanQRCode(
    List<Product>? products,
    String code,
    int orderDataQty,
    int productQty,
    int orderLevel,
    int index,
    String id,
  ) async {
    //Para ni sa continues scanning...
    // FlutterBarcodeScanner.getBarcodeStreamReceiver(
    //         "#ff6666", "Cancel", false, ScanMode.DEFAULT)!
    //     .listen((barcode) {
    //   /// barcode to be used
    // });

    var snackBar = const SnackBar(
      content: Text('Scanned matched!'),
      elevation: 10,
      duration: Duration(seconds: 3),
    );

    try {
      final scannedCode = await FlutterBarcodeScanner.scanBarcode(
        '#FC2E20',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;
      if (code == scannedCode) {
        _updateProduct(
          id,
          products![0],
          _newQtyOnHand(products, productQty, orderDataQty, index, id),
          _newOrderLevel(products, orderDataQty, orderLevel, index),
        );

        setState(() {
          _isMatch[index] = !_isMatch.elementAt(index);
          qrCode = scannedCode;
          _isDone = true;
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } else {
        _showErrorDialog('product dont matched code: $code + $scannedCode');
      }
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    } catch (e) {
      rethrow;
    }
  }

  completedOrders(Order completedOrders) {
    final order = <String, dynamic>{
      "amount": completedOrders.amount,
      "cust_contactNumber": completedOrders.number,
      "cust_id": completedOrders.customerId,
      "cust_name": completedOrders.name,
      "dateTime": DateTime.now().toIso8601String(),
      "isDone": true,
      "products":
          List<dynamic>.from(completedOrders.products!.map((x) => x.toJson())),
    };

    _database
        .child(completedPath)
        .push()
        .set(order)
        .then(
          (value) => Navigator.pop(context),
        )
        .catchError(
          (onError) => print('Something happened.'),
        );
  }

  removeOrder(String orderId) {
    _database
        .child(ordersPath + orderId)
        .remove()
        .then((value) => print('order is completed...'))
        .onError((error, stackTrace) => _showErrorDialog(error.toString()));
  }

  Future<void> _updateProduct(
    String id,
    Product updatedProduct,
    int onHand,
    int reOrder,
  ) async {
    var snackBar = const SnackBar(
      content: Text('Successfuly updated!'),
      elevation: 10,
      duration: Duration(seconds: 3),
    );

    try {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(id, updatedProduct, onHand, reOrder);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('${e.toString()} has happened.'),
          content: const Text(
            'Something unexpected happened.',
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> updateOrder() async {
    var snackBar = const SnackBar(
      content: Text('Successfuly updated!'),
      elevation: 10,
      duration: Duration(seconds: 3),
    );
    final ordersReference = _database.child(ordersPath + orderData!.orderId!);
    try {
      await ordersReference.update({'isDone': true});
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: const Text('An error occured.'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  void _showOkayDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: const Text('Response.'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _isDone = true;
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }
}
