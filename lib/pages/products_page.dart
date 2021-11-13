import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/product.dart';
import '../provider/categories_provider.dart';
import '../provider/product_provider.dart';

class ProductsPage extends StatefulWidget {
  static const routeName = '/products-page';

  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _database = FirebaseDatabase.instance.reference();
  final key = GlobalKey<AnimatedListState>();
  bool _isLoading = false;
  Future? _productsFutures;

  Future? _obtainProducts() async {
    return await Provider.of<Products>(context, listen: false)
        .fetchProducts()
        .then((value) => setState(() {
              _isLoading = true;
            }));
  }

  @override
  void initState() {
    if (mounted) {
      _productsFutures = _obtainProducts();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Product Lists',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    'Inventory',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: size.height * .2,
                child: buildCategoryScroller(size),
              ),
              const SizedBox(height: 10),
              Expanded(
                //height: size.height * .4,
                child: buildProductsView(context, size, key),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryScroller(Size size) {
    final categoryData =
        Provider.of<Categories>(context, listen: false).categories;
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) => SizedBox(
        width: size.width * .45,
        //  color: Theme.of(context).colorScheme.secondaryVariant,
        child: Consumer<Categories>(builder: (context, model, child) {
          if (model.categories != null) {
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
                            imageUrl: categoryData![index].imgUrl!,
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
                        child: Text(
                          categoryData[index].title!,
                          softWrap: true,
                          overflow: TextOverflow.visible,
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
      separatorBuilder: (ctx, _) => const SizedBox(width: 6),
      itemCount: categoryData!.length,
    );
  }

  Widget buildStream(Size size) {
    return SizedBox(
      width: size.width * .4,
      child: StreamBuilder(
        stream: _database.child('categories').limitToLast(10).onValue,
        builder: (context, snapshot) {
          final tileList = <ListTile>[];
          if (snapshot.hasData) {
            final categories = Map<String, dynamic>.from(
                (snapshot.data! as Event).snapshot.value);
            final category = Category.fromRTDB(categories);
            final categoryTile = ListTile(
              leading: Image.asset(
                category.imgUrl!,
                fit: BoxFit.cover,
              ),
              title: Text(
                category.title!,
              ),
            );
            tileList.add(categoryTile);
          }
          return Expanded(
            child: ListView(
              children: tileList,
            ),
          );
        },
      ),
    );
  }

  Widget buildProductsView(BuildContext context, Size size, Key key) {
    final productsData = Provider.of<Products>(context, listen: false).items;
    final textStyle = Theme.of(context).textTheme.headline4;
    final titleStyle = Theme.of(context).textTheme.bodyText2;
    return Consumer<Products>(
      builder: (context, data, child) => ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: productsData!.length,
        itemBuilder: (context, index) => SizedBox(
          height: 100,
          child: Stack(
            children: [
              ListTile(
                isThreeLine: false,
                leading: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: CachedNetworkImage(
                    imageUrl: productsData[index].imageUrl!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(
                  productsData[index].title!,
                  style: titleStyle,
                ),
                subtitle: Text(productsData[index].brand!),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      productsData[index].rack.toString(),
                      style: textStyle,
                    ),
                    Text(
                      'Shelf section: ${productsData[index].shelf.toString()}',
                      style: textStyle,
                    ),
                    Text(
                      'Stocks: ${productsData[index].qtyOnHand.toString()} pieces',
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ],
            alignment: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
