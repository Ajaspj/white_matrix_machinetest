import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whitematrix/model/productmodel.dart';

class Cartcontroller extends ChangeNotifier {
  final List<ProductModel> cartlist = [];
  List<ProductModel> get cart => cartlist;
  void Addcart(ProductModel product) {
    if (cartlist.contains(product)) {
      for (ProductModel element in cartlist) {
        element.quantity++;
      }
    } else {
      cartlist.add(product);
    }
    notifyListeners();
  }

  incrementQtn(int index) {
    cartlist[index].quantity++;
    notifyListeners();
  }

  decrementQtn(int index) {
    if (cartlist[index].quantity <= 1) {
      return;
    }
    cartlist[index].quantity--;
    notifyListeners();
  }

  totalPrice() {
    double total1 = 0.0;
    for (ProductModel element in cartlist) {
      total1 += element.price * element.quantity;
    }
    return total1;
  }

  static Cartcontroller of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<Cartcontroller>(
      context,
      listen: listen,
    );
  }
}
