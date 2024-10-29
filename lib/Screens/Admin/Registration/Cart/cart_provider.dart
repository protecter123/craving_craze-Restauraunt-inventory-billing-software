import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => _items;

  // double get totalAmount{
  // return _items.fold(0.0, (sum,item)=> sum + item.price * item.quantity);
  // }

  void addItem(String productId, double price) {
    // final index = _items.indexWhere((item)=> item.id == productId);
    // if (index >= 0){
    //   _items[index].quantity += 1;

    // }
    // else {
    // _items.add(CartItem(id: productId, price: price));
    // }

    notifyListeners();
  }

  void removeItem(String item) {
    _items.remove(item);
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final double price;
  int quantity;

  CartItem({required this.id, required this.price, this.quantity = 1});
}
