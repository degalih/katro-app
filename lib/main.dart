import 'package:flutter/material.dart';
import 'package:katro_v2/common/styles.dart';
import 'package:katro_v2/ui/home_page.dart';
import 'package:katro_v2/ui/login_page.dart';
import 'package:katro_v2/ui/restaurant_detail_page.dart';
import 'package:katro_v2/ui/restaurant_search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Katalog Resto',
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: primaryColor,
                onPrimary: Colors.white,
                secondary: secondaryColor,
              ),
          textTheme: myTextTheme,
        ),
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          HomePage.routeName: (context) => HomePage(
                user: ModalRoute.of(context)?.settings.arguments as String,
              ),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                restaurantId:
                    ModalRoute.of(context)?.settings.arguments as String,
              ),
          RestaurantSearchPage.routeName: (context) => RestaurantSearchPage(),
        });
  }
}
