import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whitematrix/model/productmodel.dart';

class Ordercontroller extends ChangeNotifier {
  final List<ProductModel> orderslist = [];
  List<ProductModel> get orders => orderslist;
  void addorder(ProductModel product) {
    if (orderslist.contains(product)) {
      orderslist.remove(product);
    } else {
      orderslist.add(product);
    }
    notifyListeners();
  }

  bool isExist(ProductModel product) {
    final isExist = orderslist.contains(product);
    return isExist;
  }

  static Ordercontroller of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<Ordercontroller>(
      context,
      listen: listen,
    );
  }
}
