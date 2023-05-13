import 'package:e_mart/order_history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dataclass/cart_service.dart';
import 'dataclass/notification_service.dart';
import 'dataclass/person.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late UserPerson userPerson;
  final CartService _cartService = CartService();
  double total = 0;
  List<Map<String, dynamic>> orderHistory = [];
  List<Map<String, dynamic>> cartItemsList = [];

  late final NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    userPerson = Provider.of<UserPerson>(context, listen: false);
    cartItemsList = userPerson.cartItems;
    orderHistory = userPerson.orderHistory;

    notificationService = NotificationService();
    notificationService.initializePlatformNotifications();
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
        icon: Icon(Icons.shopping_bag_outlined),
        iconColor: Colors.indigo,
        title: Text('Confirmation'),
        content: Text('Your order has been placed'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final order = {
                'date': DateTime.now().toString(),
                'orders': List<Map<String, dynamic>>.from(cartItemsList),
              };
              orderHistory.add(order);
              userPerson.updateOrderHistory(orderHistory);
              await storeOrderHistory();
              print("naya print - ${userPerson.orderHistory}");

              await notificationService.showLocalNotification(
                  id: 0,
                  title: "Order Placed ✅",
                  body:
                      "Your order of ${cartItemsList.length} items has been recieved!",
                  payload: "Order Placed Successfully!");

              userPerson.clearCart();
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
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.asset(
                  cartItemsList[index]['image'],
                  width: 60,
                  height: 60,
                ),
                title: Text(cartItemsList[index]['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: Text('\$${cartItemsList[index]['price'].toString()}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.redAccent)),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () async {
                    cartItemsList.removeAt(index);

                    userPerson.updateCart(cartItemsList);
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Total : \$${total.toString()}',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  child: Text('Checkout',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
