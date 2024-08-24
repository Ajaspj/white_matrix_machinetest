import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  bool _isFirstTimeLogin = true;
  bool _hasDiscount = false;
  int _discountPercentage = 0;

  bool get isFirstTimeLogin => _isFirstTimeLogin;
  bool get hasDiscount => _hasDiscount;
  int get discountPercentage => _discountPercentage;

  void setFirstTimeLogin(bool isFirstTime) {
    _isFirstTimeLogin = isFirstTime;
    notifyListeners();
  }

  void setDiscount(int discount) {
    _hasDiscount = true;
    _discountPercentage = discount;
    notifyListeners();
  }

  void resetDiscount() {
    _hasDiscount = false;
    _discountPercentage = 0;
    notifyListeners();
  }

  void checkFirstTimeLogin() {
    if (_isFirstTimeLogin) {}
  }

  Future<void> loginUser(String userId) async {
    checkFirstTimeLogin();
  }
}
