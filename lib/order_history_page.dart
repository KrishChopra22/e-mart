import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dataclass/cart_service.dart';
import 'dataclass/person.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late Person person;
  final CartService _cartService = CartService();
  List<Map<String, dynamic>> orderHistory = [];

  @override
  void initState() {
    super.initState();
    person = Provider.of<Person>(context, listen: false);
    orderHistory = person.orderHistory;
  }

  // Future<void> getOrderHistory() async {
  //   final orderHistories = await _cartService.getOrderHistory();
  //   setState(() {
  //     orderHistory = orderHistories;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: ListView.builder(
        itemCount: orderHistory.length,
        itemBuilder: (context, index) {
          final order = orderHistory[index];
          final cartItemsList = order['orders'] as List;

          print("ORDER HAI -    $order");
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              child: ExpansionTile(
                expandedAlignment: Alignment.centerLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Text(order['date']),
                subtitle: Text(cartItemsList.length.toString()),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
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
                            subtitle: Text(
                                '\$${cartItemsList[index]['price'].toString()}'),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
