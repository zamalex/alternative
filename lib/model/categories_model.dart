class CategoriesModel {
  int? code;
  List<Category>? data;
  String? status;
  String? message;

  CategoriesModel({this.code, this.data, this.status, this.message});

  CategoriesModel.fromJson(List<dynamic> json) {
    data = <Category>[];
    json.forEach((v) {
      data!.add(Category.fromJson(v));
    });
  }
}

class Category {
  int? id;
  int? isAlternative;
  int? parent_brand_id;
  String? image;
  String? name;
  String? status;
  String? foundation_year;
  String? origin_country;
  String? brand_description;

  Category({
    this.id,
    this.status,
    this.isAlternative,
    this.image,
    this.parent_brand_id,
    this.origin_country,
    this.brand_description,
    this.foundation_year,
    this.name,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parent_brand_id = json['parent_brand_id'];
    isAlternative = int.parse(json['isAlternative'].toString());
    image = json['brand_logo'] ?? '';
    status = json['status'].toString();
    name = json['brand_name'] ?? "--";
    origin_country = json['brand_origin_country'] ?? "--";
    foundation_year = json['brand_year_founded'] ?? "--";
    brand_description = json['brand_description'] ?? "Not Available";
  }
}
