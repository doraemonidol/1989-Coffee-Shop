import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);

    return Consumer<Product>(
      builder: (ctx, product, _) => Card(
        //borderRadius: BorderRadius.circular(10),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.background,
          ),
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                horizontalTitleGap: 5,
                leading: Container(
                  width: 70,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Image border
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(10), // Image radius
                        child: Hero(
                          tag: product.id,
                          child: FadeInImage(
                            placeholder:
                                AssetImage('assets/images/coffee-cup.png'),
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                trailing: FittedBox(
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      product.toggleFavoriteStatus(
                        authData.token,
                        authData.userId,
                      );
                    },
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        child: FittedBox(
                          child: Text(
                            product.title,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: product.ingredients.map((e) {
                            return Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.5, horizontal: 5),
                                decoration: BoxDecoration(
                                  // color: const Color(0xff7c94b6),
                                  // image: const DecorationImage(
                                  //   image: NetworkImage(
                                  //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                                  //   fit: BoxFit.cover,
                                  // ),
                                  border: Border.all(
                                    width: 1.5,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  e,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: product.id,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
