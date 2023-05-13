import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dataclass/person.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late UserPerson person;
  List<Map<String, dynamic>> orderHistory = [];

  @override
  void initState() {
    super.initState();
    person = Provider.of<UserPerson>(context, listen: false);
    orderHistory = person.orderHistory;
  }

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

          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ExpansionTile(
                expandedAlignment: Alignment.centerLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: RichText(
                  text: TextSpan(
                    text: "Order placed on ",
                    style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            "- ${order['date'].toString().substring(0, 10)}\n",
                        style: const TextStyle(
                            color: Colors.indigoAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text:
                            "at${order['date'].toString().substring(10, 19)}\n",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                tilePadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                subtitle: Text(
                    "Total Items : ${cartItemsList.length.toString()}",
                    style: const TextStyle(color: Colors.indigo, fontSize: 14)),
                children: [
                  ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartItemsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            leading: Image.asset(
                              cartItemsList[index]['image'],
                              width: 60,
                              height: 60,
                            ),
                            title: Text(cartItemsList[index]['name']),
                            subtitle: Text(
                                '\$${cartItemsList[index]['price'].toString()}',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                )),
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
