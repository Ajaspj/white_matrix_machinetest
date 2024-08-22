import 'package:flutter/material.dart';
import 'package:whitematrix/constants/colorconstants.dart/colorconstants.dart';

class OfferBadge extends StatelessWidget {
  final int discount;

  const OfferBadge({
    Key? key,
    required this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorConstants.errorRed,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '30% OFF',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
