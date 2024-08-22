import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whitematrix/model/productmodel.dart';

class Favoritecontroller extends ChangeNotifier {
  final List<ProductModel> favorateslist = [];
  List<ProductModel> get favorites => favorateslist;
  void toggleFavorite(ProductModel product) {
    if (favorateslist.contains(product)) {
      favorateslist.remove(product);
    } else {
      favorateslist.add(product);
    }
    notifyListeners();
  }

  bool isExist(ProductModel product) {
    final isExist = favorateslist.contains(product);
    return isExist;
  }

  totalPrice() {
    double total1 = 0.0;
    for (ProductModel element in favorateslist) {
      total1 += element.price * element.quantity;
    }
    return total1;
  }

  static Favoritecontroller of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<Favoritecontroller>(
      context,
      listen: listen,
    );
  }
}
