import 'package:e_mart/order_history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dataclass/cart_service.dart';
import 'dataclass/person.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage(this.cartItems, {super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  double total = 0;
  List<Map<String, dynamic>> orderHistory = [];
  List<Map<String, dynamic>> cartItemsList = [];

  @override
  void initState() {
    super.initState();
    getCartItems();
    for (var item in widget.cartItems) {
      total += item['price'];
    }
  }

  Future<void> getCartItems() async {
    final items = await _cartService.getCartItems();
    setState(() {
      cartItemsList = items;
    });
  }

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
            onPressed: () {
              setState(() {
                // orderHistory.addAll(widget.cartItems);
                Person person = Provider.of<Person>(context, listen: false);
                orderHistory = person.orderHistory;
                person.addToOrderHistory(widget.cartItems);
                storeOrderHistory();
                person.clearCart();
                cartItemsList.clear();
                storeCartItems();
                total = 0;
              });
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OrderHistoryPage(orderHistory: orderHistory)),
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
                  onPressed: () {
                    setState(() {
                      Person person =
                          Provider.of<Person>(context, listen: false);
                      person.removeFromCart(index);
                      cartItemsList.removeAt(index);
                      storeCartItems();
                      total = 0;
                      for (var item in cartItemsList) {
                        total += item['price'];
                      }
                    });
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
