import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CartService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> storeCartItems(List<Map<String, dynamic>> cartItems) async {
    try {
      final user = auth.currentUser;
      final userId = user?.uid;
      if (userId != null) {
        final cartItemsRef =
            database.ref().child('Users/${auth.currentUser!.uid}/cartItems');
        await cartItemsRef.set(cartItems);
        print('Cart items stored in Firebase for user $userId');
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error storing cart items: $e');
    }
  }

  // Future<List<Map<String, dynamic>>> getCartItems() async {
  //   try {
  //     final user = auth.currentUser;
  //     final userId = user?.uid;
  //     if (userId != null) {
  //       final cartItemsSnapshot = await database
  //           .ref()
  //           .child('Users/${auth.currentUser!.uid}/cartItems')
  //           .get();
  //       if (cartItemsSnapshot.exists) {
  //         print(cartItemsSnapshot);
  //         final List<Map<String, dynamic>> cartItemsList =
  //             List<Map<String, dynamic>>.from(
  //                 cartItemsSnapshot.value as List<Map<String, dynamic>>);
  //         print(cartItemsList);
  //         return cartItemsList;
  //       } else {
  //         return [];
  //       }
  //     } else {
  //       print('User not logged in');
  //       return [];
  //     }
  //   } catch (e) {
  //     print('Error retrieving cart items: $e');
  //     return [];
  //   }
  // }

  Future<void> storeOrderHistory(
      List<Map<String, dynamic>> orderHistory) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      if (userId != null) {
        await database
            .ref()
            .child('Users/${auth.currentUser!.uid}/orderHistory')
            .set(orderHistory);
        print('Order history stored in Firebase for user $userId');
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error storing order history: $e');
    }
  }

  // Future<List<Map<String, dynamic>>> getOrderHistory() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     final userId = user?.uid;
  //     if (userId != null) {
  //       final orderHistorySnapshot = await database
  //           .ref()
  //           .child('Users/${auth.currentUser!.uid}/orderHistory')
  //           .get();

  //       final orderHistoryValue = orderHistorySnapshot.value;
  //       if (orderHistoryValue != null) {
  //         final orderHistoryMap = orderHistoryValue as Map<dynamic, dynamic>;
  //         final orderHistoryList = orderHistoryMap.entries.map((entry) {
  //           final orderData = entry.value as Map<dynamic, dynamic>;
  //           return {
  //             'date': orderData['date'],
  //             'orders': (orderData['orders'] as List<dynamic>)
  //                 .cast<Map<String, dynamic>>(),
  //           };
  //         }).toList();
  //         return orderHistoryList;
  //       }
  //     } else {
  //       print('User not logged in');
  //     }
  //   } catch (e) {
  //     print('Error retrieving order history: $e');
  //   }
  //   return [];
  // }
}
