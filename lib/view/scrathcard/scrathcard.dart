import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/widgets.dart';
import 'package:whitematrix/controller/usercontroller.dart';
import 'package:whitematrix/view/homescreen/homescreen.dart';

class ScratchCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Scratch & Win")),
      body: Center(
        child: Scratcher(
          brushSize: 50,
          threshold: 50,
          color: Colors.grey,
          onChange: (value) {
            // Value is the percentage of scratch completion
          },
          onThreshold: () {
            // When scratching is complete
            userController.setDiscount(30); // Set 30% discount for the user
            _showDiscountDialog(context);
          },
          child: Container(
            height: 300,
            width: 300,
            color: Colors.blue,
            child: Center(
              child: Text(
                "You have won a 30% discount!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
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
          title: Text("Congratulations!"),
          content: Text("You have received a 30% discount on all products."),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  )),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
