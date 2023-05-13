import 'package:e_mart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dataclass/cart_service.dart';
import 'dataclass/person.dart';
import 'navigation_drawer.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Map<String, dynamic>> productList = [
    {
      'category': 'electronics',
      'name': 'Smartphone',
      'price': 10000,
      'image': 'assets/images/smartphone.png',
    },
    {
      'category': 'electronics',
      'name': 'Laptop',
      'price': 50000,
      'image': 'assets/images/laptop.png',
    },
    {
      'category': 'footwear',
      'name': 'Sports Shoes',
      'price': 2000,
      'image': 'assets/images/sportsshoes.png',
    },
    {
      'category': 'footwear',
      'name': 'Casual Shoes',
      'price': 1500,
      'image': 'assets/images/casualshoes.png',
    },
    {
      'category': 'apparel',
      'name': 'T-Shirt',
      'price': 500,
      'image': 'assets/images/tshirt.png',
    },
    {
      'category': 'apparel',
      'name': 'Jeans',
      'price': 1500,
      'image': 'assets/images/jeans.png',
    },
    {
      'category': 'appliances',
      'name': 'Refrigerator',
      'price': 30000,
      'image': 'assets/images/refrigerator.png',
    },
    {
      'category': 'appliances',
      'name': 'Washing Machine',
      'price': 25000,
      'image': 'assets/images/washingmachine.png',
    },
  ];

  final CartService _cartService = CartService();
  late Person person;
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    person = Provider.of<Person>(context, listen: false);
    cartItems = person.cartItems;
  }

  // Future<void> getCartItems() async {
  //   final items = await _cartService.getCartItems();
  //   setState(() {
  //     cartItems.clear();
  //     cartItems = items;
  //   });
  // }

  Future<void> storeCartItems() async {
    await _cartService.storeCartItems(cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('e-Mart'),
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: Image.asset(
                  productList[index]['image'],
                  width: 50,
                  height: 50,
                ),
                title: Text(productList[index]['name']),
                subtitle: Text('\$${productList[index]['price']}'),
                trailing: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    setState(() {
                      // getCartItems();
                      cartItems.add(productList[index]);
                      person.updateCart(cartItems);
                      storeCartItems();
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
      drawer: const NavigationDrawerWidget(),
    );
  }
}
