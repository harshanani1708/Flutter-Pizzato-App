import 'package:flutter/material.dart';
import '';

class CartModel extends ChangeNotifier {
  String name;
  String size;
  String cheeseCount;
  String beaconCount;
  String onionCount;
  String imageUrl;
  String price;

  CartModel(
      {this.name,
      this.cheeseCount,
      this.beaconCount,
      this.onionCount,
      this.imageUrl,
      this.price,
      this.size});
}

class Cart with ChangeNotifier {
  List<CartModel> _cartList = [];

  int _totalPrice = 0;

  addtoCart(CartModel cart) {
    _cartList.add(cart);
    _totalPrice += int.parse(cart.price);
    notifyListeners();
  }

  int get count {
    return _cartList.length;
  }

  List<CartModel> get cartItems {
    return _cartList;
  }

  int get totalAmount {
    return _totalPrice;
  }

  void removeItem(int index) {
    _totalPrice = _totalPrice - int.parse(_cartList[index].price);

    _cartList.removeAt(index);
    notifyListeners();
  }

  void clearList() {
    _cartList.clear();
    _totalPrice = 0;
    notifyListeners();
  }
}
