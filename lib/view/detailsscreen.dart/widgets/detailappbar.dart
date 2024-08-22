import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whitematrix/controller/favcontroller.dart';
import 'package:whitematrix/model/productmodel.dart';

class DetailAppBar extends StatelessWidget {
  final ProductModel product;

  const DetailAppBar({super.key, required this.product});

  void _shareProduct(BuildContext context) {
    final String shareMessage =
        'Check out this product: ${product.title}\nPrice: ₹${product.price}\n\n${product.image}';

    Share.share(shareMessage);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Favoritecontroller.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          Spacer(),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.all(15),
            ),
            onPressed: () => _shareProduct(context),
            icon: Icon(Icons.share_outlined),
          ),
          SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {
              provider.toggleFavorite(product);
            },
            icon: Icon(
              provider.isExist(product)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.black,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
