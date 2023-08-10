import 'package:coffee1989/widgets/number_stepper.dart';
import 'package:flutter/services.dart';

import '../widgets/cart_button.dart';
import '../widgets/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../helpers/coffee1989_icons.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final radioModelList = {
    'temp': [
      RadioModel(
        isSelected: true,
        buttonText: 'Hot',
        icon: Icons.local_fire_department_outlined,
      ),
      RadioModel(
        isSelected: false,
        buttonText: 'Cold',
        icon: Icons.ac_unit_outlined,
      ),
    ],
    'size': [
      RadioModel(
        isSelected: false,
        buttonText: 'Small',
        icon: Coffee1989.cup_1,
        iconSize: 25,
      ),
      RadioModel(
        isSelected: true,
        buttonText: 'Medium',
        icon: Coffee1989.cup_1,
        iconSize: 30,
      ),
      RadioModel(
        isSelected: false,
        buttonText: 'Large',
        icon: Coffee1989.cup_1,
        iconSize: 35,
      ),
    ],
    'iced': [
      RadioModel(
        isSelected: false,
        buttonText: 'Light Ice',
        icon: Coffee1989.light_ice_2,
        iconSize: 35,
      ),
      RadioModel(
        isSelected: true,
        buttonText: 'Medium Ice',
        icon: Coffee1989.medium_ice,
        iconSize: 35,
      ),
      RadioModel(
        isSelected: false,
        buttonText: 'Full Ice',
        icon: Coffee1989.full_ice,
        iconSize: 35,
      ),
    ],
  };

  var _isInit = true;
  double _money = 0.0;
  var _cupSize = 'Medium';
  var _ice = 'Medium Ice';
  var _temp = 'Hot';
  var _amount = 1;
  var _price = 0.0;
  var _note = '';
  //final String title;

  double get money {
    return (_price +
            (_cupSize == 'Small'
                ? -2.00
                : _cupSize == 'Medium'
                    ? 0
                    : 3)) *
        _amount;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      final loadedProduct = Provider.of<Products>(
        context,
        listen: false,
      ).findById(productId);
      _price = loadedProduct.price;
      print(_price);
      setState(() {
        _money = money;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      bottomNavigationBar: BottomAppBar(
        height: 130,
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        color: Colors.white,
        child: Wrap(
          children: [
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '\$$_money',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  Provider.of<Cart>(context, listen: false).addItem(
                    CartItem(
                      id: loadedProduct.id,
                      title: loadedProduct.title,
                      price: money / _amount,
                      description: '$_temp | $_cupSize | $_ice',
                      note: _note,
                      quantity: _amount.toInt(),
                    ),
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added item to cart!'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            Provider.of<Cart>(context, listen: false)
                                .removeSingleItem(
                                    CartItem(
                                      id: loadedProduct.id,
                                      title: loadedProduct.title,
                                      price: money / _amount,
                                      note: _note,
                                      description: '$_temp | $_cupSize | $_ice',
                                    ),
                                    _amount.toInt());
                          }),
                    ),
                  );
                },
                child: FittedBox(
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Add to Cart',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            //floating: true,
            //snap: true,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 20),
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                color:
                    Theme.of(context).colorScheme.inverseSurface.withAlpha(150),
                height: 25,
                child: FittedBox(
                  child: Text(
                    loadedProduct.title,
                  ),
                ),
              ),
              background: ClipRRect(
                borderRadius: BorderRadius.circular(30), // Image border
                child: Container(
                  margin: EdgeInsets.only(top: 60),
                  padding: EdgeInsets.all(20),
                  child: Hero(
                    tag: loadedProduct.id,
                    child: Image.network(
                      loadedProduct.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              CartButton(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ), // Image border
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35.0, vertical: 15),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 10,
                            ),
                            child: Text(
                              loadedProduct.description,
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                              softWrap: true,
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Amount',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              FittedBox(
                                child: NumberStepper(
                                  initialValue: 1,
                                  min: 1,
                                  max: 99,
                                  step: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      _amount = value;
                                      _money = money;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Select ',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              FittedBox(
                                child: CustomRadio(
                                  data: radioModelList['temp']!,
                                  onChanged: (value) {
                                    _temp = radioModelList['temp']![value]
                                        .buttonText;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Size ',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              FittedBox(
                                child: CustomRadio(
                                  data: radioModelList['size']!,
                                  onChanged: (p0) => setState(
                                    () {
                                      _cupSize = radioModelList['size']![p0]
                                          .buttonText;
                                      _money = money;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ice ',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              FittedBox(
                                child: CustomRadio(
                                  data: radioModelList['iced']!,
                                  onChanged: (value) {
                                    _ice = radioModelList['iced']![value]
                                        .buttonText;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          TextField(
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.top,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: 'Note',
                              border: OutlineInputBorder(),
                              hintText: 'Enter your note here',
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                            maxLines: 3,
                            onTapOutside: (event) => FocusScope.of(context)
                                .requestFocus(FocusNode()),
                            onChanged: (value) => _note = value,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
