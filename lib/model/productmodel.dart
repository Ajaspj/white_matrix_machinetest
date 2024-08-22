class ProductModel {
  final String title;
  final String description;
  final String image;
  final String review;
  final String seller;
  final double price;
  final double rate;
  int quantity;

  ProductModel({
    required this.title,
    required this.review,
    required this.description,
    required this.image,
    required this.price,
    required this.seller,
    required this.rate,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'review': review,
      'seller': seller,
      'price': price,
      'rate': rate,
      'quantity': quantity,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      review: map['review'] ?? '',
      seller: map['seller'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      rate: map['rate']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }
}
