import 'package:flutter/cupertino.dart';

class LocationModel extends ChangeNotifier {
  String address;

  void setAddress(String newAddress) {
    address = newAddress;
    notifyListeners();
  }

  String getAddress() {
    return address;
  }
}
