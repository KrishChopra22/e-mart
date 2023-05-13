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
  late UserPerson person;
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    person = Provider.of<UserPerson>(context, listen: false);
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
        actions: [
          IconButton(
            padding: EdgeInsets.all(4),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            icon: Icon(Icons.shopping_cart),
            iconSize: 30,
          ),
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(4.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(8),
                leading: Image.asset(
                  productList[index]['image'],
                  width: 60,
                  height: 60,
                ),
                title: Text(productList[index]['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: Text('\$${productList[index]['price']}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.redAccent)),
                trailing: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // getCartItems();
                      cartItems.add(productList[index]);
                      person.updateCart(cartItems);
                      storeCartItems();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      shape: const StadiumBorder()),
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      drawer: const NavigationDrawerWidget(),
    );
  }
}
