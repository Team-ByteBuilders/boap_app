class ShopDetails {
  final String shopName;
  final String shopUpi;
  final List<ProductDetails> allProducts;
  final List<ProductDetails> topProducts;
  ShopDetails(
      {required this.shopName,
      required this.shopUpi,
      required this.allProducts,
      required this.topProducts});
}

class ProductDetails {
  final String name;
  final int price;

  ProductDetails({required this.name, required this.price});

  factory ProductDetails.fromMap(Map<String, dynamic> map) =>
      ProductDetails(name: map['name'], price: map['price']);
}
