import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_real_estate/providers/Agent_Provider.dart';
import 'package:smart_real_estate/providers/AuthProvider.dart';
import 'package:smart_real_estate/providers/estate_provider.dart';
import 'package:smart_real_estate/providers/favourite_provider.dart';
import 'package:smart_real_estate/screens/FavouritePage.dart';
import 'package:smart_real_estate/screens/FeaturedList.dart';
import 'package:smart_real_estate/screens/HomePage.dart';
import 'package:smart_real_estate/screens/Otp.dart';
import 'package:smart_real_estate/screens/Personal_Profile_Screen.dart';
import 'package:smart_real_estate/screens/Register.dart';
import 'package:smart_real_estate/screens/LoginOptionPage.dart';
import 'package:smart_real_estate/screens/Review.dart';
import 'package:smart_real_estate/screens/Search_Page.dart';
import 'package:smart_real_estate/screens/TopAgentPage.dart';
import 'package:smart_real_estate/screens/addImageProperty.dart';
import 'package:smart_real_estate/screens/add_estate.dart';
import 'package:smart_real_estate/screens/chatScreen.dart';
import 'package:smart_real_estate/screens/loginForm.dart';
import 'package:smart_real_estate/screens/notification_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
        ChangeNotifierProvider(create: (_) => EstateProvider()),
        ChangeNotifierProvider(create: (_) => AgentProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginOptionPage(),
        '/Login': (context) => LoginFormPage(),
        '/Otp': (context) => OtpScreen(),
        '/Register': (context) => RegisterScreen(),
        '/Home': (context) => HomePage(),
        '/FeatureList': (context) => FeatureList(),
        '/NotificationScreen': (context) => NotificationScreen(),
        '/Favourite_Page': (context) => FavouritePage(),
        '/Add_Estate': (context) => AddEstatePage(),
        '/Search_Page': (context) => SearchPage(),
        '/Top_Agent_Page': (context) => Top_Agent_Page(),
        '/My_Profile': (context) =>  Personal_Profile_Screen(),
        '/Review': (context) =>  ReviewScreen(),
        '/add_image': (context) =>  AddListingScreen(),
        '/chat_screen': (context) =>  ChatScreen(),
      },
    );
  }
}
