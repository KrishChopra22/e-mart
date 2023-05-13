import 'package:e_mart/cart_page.dart';
import 'package:e_mart/dataclass/person.dart';
import 'package:e_mart/order_history_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_screens/login_screen.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    UserPerson userPerson = Provider.of<UserPerson>(context, listen: false);
    final username = userPerson.name;
    return Drawer(
      width: 240,
      child: Material(
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Text(
              "Hey $username!",
              style: const TextStyle(
                  color: Colors.indigo,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            const Divider(color: Colors.indigo),
            buildMenuItem(
              drawerText: 'My Cart',
              drawerIcon: Icons.shopping_cart_outlined,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(
              height: 20,
            ),
            buildMenuItem(
              drawerText: 'My Orders',
              drawerIcon: Icons.history_outlined,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(color: Colors.indigo),
            const SizedBox(
              height: 20,
            ),
            buildMenuItem(
              drawerText: 'LogOut',
              drawerIcon: Icons.logout,
              onClicked: () => selectedItem(context, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String drawerText,
    required IconData drawerIcon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.black;
    return ListTile(
      leading: Icon(
        drawerIcon,
        color: color,
      ),
      title: Text(drawerText),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int i) {
    Navigator.of(context).pop();
    switch (i) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const CartPage()));
        break;
      case 1:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OrderHistoryPage()));
        break;
      case 2:
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
    }
  }
}
