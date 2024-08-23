import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whitematrix/model/productmodel.dart';

class Homescreencontroller with ChangeNotifier {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("products");

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  String _searchText = "";
  String get searchText => _searchText;

  // Method to fetch products from Firestore
  Future<void> fetchProducts() async {
    final snapshot = await collectionRef.get();
    _products = snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    notifyListeners();
  }

  // Method to set search text
  void setSearchText(String text) {
    _searchText = text.toLowerCase();
    notifyListeners();
  }

  // Method to get filtered products based on the search text
  List<ProductModel> get filteredProducts {
    if (_searchText.isEmpty) {
      return _products;
    }
    return _products.where((product) {
      return product.title.toLowerCase().contains(_searchText);
    }).toList();
  }
}
