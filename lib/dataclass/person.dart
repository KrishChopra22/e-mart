import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseDatabase database = FirebaseDatabase.instance;

class UserPerson extends ChangeNotifier {
  late String name;
  late String uid;
  late String email;
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> orderHistory = [];

  void fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    email = json['email'];
    if (json['cartItems'] != null) {
      cartItems = List<Map<String, dynamic>>.generate(
          json['cartItems'].length,
          (index) => Map<String, dynamic>.from(
              json['cartItems'][index] as Map<dynamic, dynamic>));
    }
    if (json['orderHistory'] != null) {
      orderHistory = List<Map<String, dynamic>>.generate(
          json['orderHistory'].length,
          (index) => Map<String, dynamic>.from(
              json['orderHistory'][index] as Map<dynamic, dynamic>));
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'email': email,
        'cartItems': cartItems,
        'orderHistory': orderHistory
      };

  Future<void> retrieveBasicInfo(String uid) async {
    final userSnapshot = await database.ref().child('Users/$uid').get();
    Map<String, dynamic> userMap =
        Map<String, dynamic>.from(userSnapshot.value as Map<dynamic, dynamic>);

    fromJson(userMap);
    notifyListeners();
  }

  // Future<void> addToCart(Map<String, dynamic> item) async {
  //   cartItems.add(item);
  //   await database.ref('Users/${auth.currentUser?.uid}').update(toJson());
  //   print("Item added to cart - user updated");
  //   notifyListeners();
  // }

  // Future<void> removeFromCart(int index) async {
  //   cartItems.removeAt(index);
  //   await database.ref('Users/${auth.currentUser?.uid}').update(toJson());
  //   print("Item removed from cart - user updated");
  //   notifyListeners();
  // }

  // Future<void> addToOrderHistory(List<Map<String, dynamic>> orders) async {
  //   final order = {
  //     'date': DateTime.now().toString(),
  //     'orders': orders,
  //   };
  //   orderHistory.add(order);
  //   await database.ref('Users/${auth.currentUser?.uid}').update(toJson());
  //   print("Added to my orders - user updated");
  //   notifyListeners();
  // }
  void addToCart(Map<String, dynamic> item) {
    cartItems.add(item);
    notifyListeners();
  }

  void updateCart(List<Map<String, dynamic>> cartItemsList) {
    cartItems = cartItemsList;
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  updateOrderHistory(List<Map<String, dynamic>> orders) {
    orderHistory = orders;
    print(orderHistory);
    notifyListeners();
    // storeOrderHistory();
  }
}
