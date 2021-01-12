class Product {
  String orderId;
  String productId;
  String productName;
  String productImage;
  String description;
  String cateName;
  int quantity;
  int soldItems;
  double price;

  Product({
    this.orderId,
    this.productId,
    this.productName,
    this.productImage,
    this.description,
    this.quantity,
    this.cateName,
    this.soldItems,
    this.price,
  });

  static List<Product> parseProductList(map) {
    var list = map['data'] as List;
    return list.map((product) => Product.fromJson(product)).toList();
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    orderId: json["orderId"] ?? '',
    productId: json["productId"],
    productName: json["productName"],
    productImage: json["productImage"],
    description: json["description"],
    cateName: json["cateName"],
    quantity: int.parse(json["quantity"].toString()),
    price: double.tryParse(json["price"].toString()) ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "productImage": productImage,
    "quantity": quantity,
    "price": price,
  };
}
