import 'package:coffee1989/providers/music_player.dart';

import '../providers/user.dart';
import './product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class FeatureScreen extends StatefulWidget {
  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  var _deviceSize;
  var _isLoading1 = false;
  var _isLoading2 = false;
  @override
  void dispose() async {
    super.dispose();
  }

  @override
  void initState() {
    print('initState BlankSpace');
    Provider.of<MusicPlayer>(context, listen: false)
        .playSong('sounds/BlankSpace.mp3');
    setState(() {
      _isLoading1 = true;
      _isLoading2 = true;
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((value) => setState(() {
                _isLoading1 = false;
              }));
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<User>(context, listen: false)
          .fetchAndSetUser(context)
          .then((value) => setState(() {
                _isLoading2 = false;
              }));
    });
    super.initState();
  }

  Widget buildFeatureItem(
    Product product,
    BuildContext context,
  ) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        padding: EdgeInsets.only(
          top: 20,
        ),
        width: 400,
        height: _deviceSize.height * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: _deviceSize.height * 0.5,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              product.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                  ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              product.description,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    //color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
              maxLines: 4,
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id,
                );
              },
              child: Text('Order Now'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Products>(context).featureItem;
    _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Image(
          image: AssetImage('assets/images/logo.png'),
          height: 50,
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
      ),
      body: _isLoading1 || _isLoading2
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.only(
                top: 70,
              ),
              child: Center(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: ListWheelScrollView(
                    itemExtent: _deviceSize.width * 0.8,
                    children: items.map(
                      (product) {
                        return buildFeatureItem(product, context);
                      },
                    ).toList(),
                    //magnification: 1.5,
                    //useMagnifier: true,
                    physics: FixedExtentScrollPhysics(),
                    diameterRatio: 4,
                    squeeze: 0.95,
                    offAxisFraction: 0.4,
                  ),
                ),
              ),
            ),
    );
  }
}
