import 'package:flutter/material.dart';

Widget Bottom_Navigation_Bar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed, // Keeps icons centered if labels are hidden
    currentIndex: currentIndex,
    selectedItemColor: Colors.blue[900], // Color for the active icon
    unselectedItemColor: Colors.grey,    // Color for inactive icons
    showSelectedLabels: false,           // Hides labels to keep it clean
    showUnselectedLabels: false,
    onTap: (value) {
      // Prevent reloading the same page
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
          Navigator.pushNamed(context, "/My_Profile"); // Assuming 3 is Profile
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