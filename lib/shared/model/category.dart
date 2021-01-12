
class Category {
  String cateId;
  String cateName;
  String cateImage;
  String createdAt;
  String updatedAt;

  Category({this.cateId, this.cateName, this.cateImage, this.createdAt,
      this.updatedAt});

  static List<Category> parseCategoryList(map) {
    var list = map['data'] as List;
    return list.map((category) => Category.fromJson(category)).toList();
  }

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    cateId: json["cateId"] ?? '',
    cateName: json["cateName"],
    cateImage: json["cateImage"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

}