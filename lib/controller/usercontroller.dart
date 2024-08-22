import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  bool _isFirstTimeLogin = true; // Assume true for the first login
  bool _hasDiscount = false; // To track if the user has received the discount
  int _discountPercentage = 0; // Stores the discount percentage

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

  // Call this method after user logs in to check if it's their first login
  void checkFirstTimeLogin() {
    if (_isFirstTimeLogin) {
      // Logic to check first time login
      // This can be a check from your database or local storage
    }
  }

  // Method to handle user login
  Future<void> loginUser(String userId) async {
    // Logic to authenticate and login user
    checkFirstTimeLogin();
  }
}
