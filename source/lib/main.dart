import './screens/feature_screen.dart';
import './screens/reward_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/tabs_screen.dart';
import './screens/order_success_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './providers/redeem.dart';
import './providers/user.dart';
import './providers/rewards.dart';
import './providers/music_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MusicPlayer(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProduct) => Products(
            auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.items,
          ),
          create: (ctx) => Products('', '', []),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
          create: (ctx) => Orders('', '', []),
        ),
        ChangeNotifierProxyProvider<Auth, Rewards>(
          update: (ctx, auth, previousRewards) => Rewards(
            auth.token,
            auth.userId,
          ),
          create: (ctx) => Rewards('', ''),
        ),
        ChangeNotifierProxyProvider<Auth, Redeems>(
          update: (ctx, auth, previousOrders) => Redeems(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.redeems,
          ),
          create: (ctx) => Redeems('', '', []),
        ),
        ChangeNotifierProxyProvider2<Auth, Cart, User>(
          update: (ctx, auth, cart, previousUser) {
            print('notify auth cart user');
            if (previousUser!.token == '') {
              return User(
                  authToken: auth.token,
                  userId: auth.userId,
                  updateMainCart: cart.updateCart);
            } else
              return User(
                authToken: auth.token,
                userId: auth.userId,
                updateMainCart: cart.updateCart,
                newProduct: cart.items,
                address: previousUser.address,
                email: previousUser.email,
                name: previousUser.name,
                imageUrl: previousUser.imageUrl,
                loyaltyPoints: previousUser.loyaltyPoints,
                phoneNumber: previousUser.phoneNumber,
              );
          },
          create: (ctx) => User(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: '1989',
          theme: FlexThemeData.light(
            colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xff19647e),
              onPrimary: Color(0xffffffff),
              primaryContainer: Color(0xffa1cbcf),
              onPrimaryContainer: Color(0xff0e1111),
              secondary: Color(0xff0093c7),
              onSecondary: Color(0xffffffff),
              secondaryContainer: Color(0xffc3e7ff),
              onSecondaryContainer: Color(0xff101314),
              tertiary: Color(0xfffeb716),
              onTertiary: Color(0xff000000),
              tertiaryContainer: Color(0xffffdea5),
              onTertiaryContainer: Color(0xff14120e),
              error: Color(0xffb00020),
              onError: Color(0xffffffff),
              errorContainer: Color(0xfffcd8df),
              onErrorContainer: Color(0xff141213),
              background: Color(0xfff8fafb),
              onBackground: Color(0xff090909),
              surface: Color(0xfff8fafb),
              onSurface: Color(0xff090909),
              surfaceVariant: Color(0xffe2e6e7),
              onSurfaceVariant: Color(0xff111212),
              outline: Color(0xff7c7c7c),
              outlineVariant: Color(0xffc8c8c8),
              shadow: Color(0xff000000),
              scrim: Color(0xff000000),
              inverseSurface: Color(0xff111313),
              onInverseSurface: Color(0xfff5f5f5),
              inversePrimary: Color(0xffa9dbed),
              surfaceTint: Color(0xff19647e),
            ),
            scheme: FlexScheme.materialBaseline,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 7,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 10,
              blendOnColors: false,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              inputDecoratorBorderType: FlexInputBorderType.underline,
              inputDecoratorUnfocusedBorderIsColored: false,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            fontFamily: 'Poppins',
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              titleMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              titleSmall: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              bodyLarge: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              bodySmall: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          home: auth.isAuth
              ? TabsScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(context),
                  builder: (cxt, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            OrderSuccessScreen.routeName: (ctx) => OrderSuccessScreen(),
            RewardScreen.routeName: (ctx) => RewardScreen(),
          },
        ),
      ),
    );
  }
}
