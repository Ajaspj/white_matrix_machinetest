import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whitematrix/constants/colorconstants.dart/colorconstants.dart';
import 'package:whitematrix/controller/cartcontroller.dart';
import 'package:whitematrix/controller/favcontroller.dart';
import 'package:whitematrix/model/productmodel.dart';
import 'package:whitematrix/view/detailsscreen.dart/details.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isHorizontal;

  const ProductCard({
    Key? key,
    required this.product,
    this.isHorizontal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Favoritecontroller.of(context);
    final cartProvider = Provider.of<Cartcontroller>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(product: product),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: isHorizontal ? 4.0 : 8.0,
          horizontal: 5.0,
        ),
        width: isHorizontal ? 150 : double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorConstants.primaryWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isHorizontal
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        height: isHorizontal ? 100 : 120,
                        width: isHorizontal ? 150 : double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        favoriteProvider.toggleFavorite(product);
                      },
                      child: Icon(
                        favoriteProvider.isExist(product)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: ColorConstants.accentBlue,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: ColorConstants.primaryBlack,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\₹${product.price}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: ColorConstants.primaryGreen,
                    ),
                  ),
                  Text(
                    "${product.quantity}",
                    style: TextStyle(
                      fontSize: 13,
                      color: ColorConstants.lightGray,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                cartProvider.Addcart(product);
                const snackBar = SnackBar(
                  content: Text(
                    "Successfully added to cart!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  duration: Duration(seconds: 1),
                  backgroundColor: ColorConstants.primaryGreen,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: SizedBox(
                child: Center(
                  child: Container(
                    height: 25,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorConstants.primaryGreen,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Add to cart",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
