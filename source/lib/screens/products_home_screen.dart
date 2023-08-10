import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/redeem.dart';
import '../widgets/loyalty_card.dart';
import '../widgets/products_grid.dart';
import '../providers/products.dart';
import '../widgets/cart_button.dart';
import '../providers/user.dart';
import '../providers/music_player.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsHomeScreen extends StatefulWidget {
  @override
  State<ProductsHomeScreen> createState() => _ProductsHomeScreenState();

  AppBar get appBar => _ProductsHomeScreenState().appBar;
}

class _ProductsHomeScreenState extends State<ProductsHomeScreen> {
  var _showOnlyFavorites = false;
  var _isLoading1 = false;
  var _isLoading2 = false;
  var _isLoading3 = false;

  @override
  void initState() {
    Provider.of<MusicPlayer>(context, listen: false)
        .playSong('sounds/WelcomeToNewYorkInstrumental.mp3');
    setState(() {
      _isLoading1 = true;
      _isLoading2 = true;
      _isLoading3 = true;
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((value) => setState(() {
                _isLoading1 = false;
              }));
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Redeems>(context, listen: false)
          .fetchAndSetRedeems()
          .then((value) => setState(() {
                _isLoading2 = false;
              }));
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<User>(context, listen: false)
          .fetchAndSetUser(context)
          .then((value) => setState(() {
                _isLoading3 = false;
              }));
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  void setFavorite() {
    setState(() {
      _showOnlyFavorites = !_showOnlyFavorites;
    });
  }

  String get _greeting {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'morning';
    }
    if (hour < 17) {
      return 'afternoon';
    }
    return 'evening';
  }

  AppBar get appBar {
    return AppBar(
      toolbarHeight: 80,
      //backgroundColor: Color(0xffffd8e4),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good ${_greeting},',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(162, 158, 158, 158),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Taylor Swift',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text('Only Favorites'),
              value: FilterOptions.Favorites,
            ),
            PopupMenuItem(
              child: Text('Show All'),
              value: FilterOptions.All,
            ),
          ],
          icon: Icon(Icons.more_vert),
          onSelected: (FilterOptions selectedValue) {
            setFavorite();
          },
        ),
        CartButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        //backgroundColor: Color(0xffffd8e4),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good ${_greeting},',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(162, 158, 158, 158),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${Provider.of<User>(context, listen: false).name}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              _showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () => setFavorite(),
          ),
          CartButton(Theme.of(context).colorScheme.secondary),
        ],
      ),
      body: _isLoading1 || _isLoading2 || _isLoading3
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: [
                  LoyaltyCard(),
                  Expanded(child: ProductsGrid(_showOnlyFavorites)),
                ],
              ),
            ),
    );
  }
}
