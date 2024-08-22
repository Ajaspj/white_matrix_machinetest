import 'package:flutter/material.dart';
import 'package:order_tracker/order_tracker.dart';

class Trackorderscreen extends StatefulWidget {
  const Trackorderscreen({Key? key}) : super(key: key);

  @override
  State<Trackorderscreen> createState() => _TrackorderscreenState();
}

class _TrackorderscreenState extends State<Trackorderscreen> {
  List<TextDto> orderList = [
    TextDto("Your order has been placed", "Sat, 15th Jun '24 - 10:47pm"),
    TextDto("Seller ha processed your order", "Sun, 27th Jun '24 - 10:19am"),
    TextDto("Your item has been picked up by courier partner.",
        "Tue, 29th Jun '24 - 5:00pm"),
  ];

  List<TextDto> shippedList = [
    TextDto("Your order has been shipped", "Tue, 29th Jun '24 - 5:04pm"),
    TextDto("Your item has been received in the nearest hub to you.", null),
  ];

  List<TextDto> outOfDeliveryList = [
    TextDto("Your order is out for delivery", "Thu, 31th Jun '24 - 2:27pm"),
  ];

  List<TextDto> deliveredList = [
    TextDto("Your order has been delivered", "Thu, 31th Jun '24 - 3:58pm"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track order"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: OrderTracker(
          status: Status.delivered,
          activeColor: Colors.green,
          inActiveColor: Colors.grey[300],
          orderTitleAndDateList: orderList,
          shippedTitleAndDateList: shippedList,
          outOfDeliveryTitleAndDateList: outOfDeliveryList,
          deliveredTitleAndDateList: deliveredList,
        ),
      ),
    );
  }
}
