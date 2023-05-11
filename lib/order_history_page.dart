import 'package:flutter/material.dart';

import 'dataclass/cart_service.dart';

class OrderHistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> orderHistory;

  const OrderHistoryPage({Key? key, required this.orderHistory})
      : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final CartService _cartService = CartService();
  List<Map<String, dynamic>> orderHistory = [];

  // @override
  // void initState() {
  //   super.initState();
  //   getOrderHistory();
  // }

  Future<void> getOrderHistory() async {
    final orderHistories = await _cartService.getOrderHistory();
    setState(() {
      orderHistory = orderHistories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: ListView.builder(
        itemCount: widget.orderHistory.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text(orderHistory[index]['orders'][0]['name']),
                subtitle: Text(
                    '\$${orderHistory[index]['orders'][0]['price'].toString()} - ${orderHistory[index]['date']}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
