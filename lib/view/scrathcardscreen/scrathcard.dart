import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/widgets.dart';
import 'package:whitematrix/controller/usercontroller.dart';
import 'package:whitematrix/model/productmodel.dart';
import 'package:whitematrix/view/homescreen/homescreen.dart';

class ScratchCardScreen extends StatefulWidget {
  final List<ProductModel> products;

  ScratchCardScreen({required this.products});

  @override
  _ScratchCardScreenState createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen> {
  bool _isScratched = false;
  ProductModel? _randomProduct;

  @override
  void initState() {
    super.initState();
    if (widget.products.isNotEmpty) {
      _randomProduct =
          widget.products[Random().nextInt(widget.products.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Scratch & Win")),
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (_randomProduct != null)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You have won:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _randomProduct!.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "\₹${_randomProduct!.price}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              Scratcher(
                brushSize: 50,
                threshold: 50,
                color: Colors.blue.withOpacity(1),
                onChange: (value) {
                  if (!_isScratched) {
                    setState(() {
                      _isScratched = true;
                    });
                  }
                },
                onThreshold: () {
                  userController.setDiscount(30);
                  _showDiscountDialog(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              if (!_isScratched)
                Center(
                  child: Text(
                    "Scratch Here!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiscountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_randomProduct != null
              ? "Congratulations!"
              : "Better luck next time!"),
          content: Text(_randomProduct != null
              ? "You have received a product for free: ${_randomProduct!.title}"
              : "No products available."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
