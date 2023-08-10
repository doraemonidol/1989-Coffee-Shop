import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatefulWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        widget.showFavs ? productsData.favoriteItems : productsData.items;

    return ListView.builder(
      padding: const EdgeInsets.all(15.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 3),
          child: ProductItem(),
        ),
      ),
    );
  }
}
