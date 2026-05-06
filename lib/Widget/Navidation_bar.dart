import 'package:flutter/material.dart';

Widget Bottom_Navigation_Bar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: currentIndex,
    selectedItemColor: Colors.blue[900],
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    onTap: (value) {
      if (value == currentIndex) return;

      switch (value) {
        case 0:
          Navigator.pushNamed(context, "/Home");
          break;
        case 1:
          Navigator.pushNamed(context, "/Search_Page");
          break;
        case 2:
          Navigator.pushNamed(context, "/Favourite_Page");
          break;
        case 3:
          Navigator.pushNamed(context, "/My_Profile");
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
      BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
    ],
  );
}