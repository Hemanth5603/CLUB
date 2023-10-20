import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DropDownButton extends StatefulWidget {
  const DropDownButton({super.key});

  @override
  State<DropDownButton> createState() => _DropDownButtonState();
}

class MenuItem {
  final String title;
  final IconData icon;

  MenuItem({required this.title, required this.icon});
}



class _DropDownButtonState extends State<DropDownButton> {
  final List<MenuItem> menuItems = [
    MenuItem(title: 'My Orders', icon: Icons.shopping_bag),
    MenuItem(title: 'Offers', icon: Icons.local_offer),
    MenuItem(title: 'Help', icon: Icons.help),
    MenuItem(title: 'Logout', icon: Icons.logout),
  ];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
          child: Container(
            width: w,
            child: DropdownButton<MenuItem>(
              icon: Icon(Icons.menu),
              onChanged: (MenuItem? selectedItem) {
                // Handle the selected menu item here
                if (selectedItem != null) {
                  print('Selected: ${selectedItem.title}');
                }
              },
              items: menuItems.map<DropdownMenuItem<MenuItem>>((MenuItem item) {
                return DropdownMenuItem<MenuItem>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(item.icon),
                      SizedBox(width: 10),
                      Text(item.title),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
    );
  }
}