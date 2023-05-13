import 'package:e_mart/order_history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dataclass/cart_service.dart';
import 'dataclass/person.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Person person;
  final CartService _cartService = CartService();
  double total = 0;
  List<Map<String, dynamic>> orderHistory = [];
  List<Map<String, dynamic>> cartItemsList = [];

  @override
  void initState() {
    super.initState();
    person = Provider.of<Person>(context, listen: false);
    cartItemsList = person.cartItems;
    orderHistory = person.orderHistory;
    for (var item in cartItemsList) {
      total += item['price'];
    }
  }

  // Future<void> getCartItems() async {
  //   final items = await _cartService.getCartItems();
  //   setState(() {
  //     cartItemsList = items;
  //   });
  // }

  Future<void> storeCartItems() async {
    await _cartService.storeCartItems(cartItemsList);
  }

  Future<void> storeOrderHistory() async {
    await _cartService.storeOrderHistory(orderHistory);
  }

  void _placeOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Your order has been placed.'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final order = {
                'date': DateTime.now().toString(),
                'orders': List<Map<String, dynamic>>.from(cartItemsList),
              };
              orderHistory.add(order);
              person.updateOrderHistory(orderHistory);
              await storeOrderHistory();
              print("naya print - ${person.orderHistory}");
              person.clearCart();
              cartItemsList.clear();
              await storeCartItems();
              total = 0;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderHistoryPage()),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItemsList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: Image.asset(
                  cartItemsList[index]['image'],
                  width: 50,
                  height: 50,
                ),
                title: Text(cartItemsList[index]['name']),
                subtitle: Text('\$${cartItemsList[index]['price'].toString()}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    cartItemsList.removeAt(index);

                    person.updateCart(cartItemsList);
                    await storeCartItems();
                    total = 0;
                    for (var item in cartItemsList) {
                      total += item['price'];
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _placeOrder,
        child: Icon(Icons.check),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Total: \$${total.toString()}'),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  child: Text('Checkout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
