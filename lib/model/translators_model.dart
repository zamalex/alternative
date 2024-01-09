import 'package:translatorclient/model/categories_model.dart';
import 'package:translatorclient/model/languages_response.dart';

class TranslatorsModel {
  List<Product>? translators;
  TranslatorsModel({this.translators});

  TranslatorsModel.fromJson(List<dynamic> json) {
    translators = <Product>[];
    json.forEach((v) {
      translators!.add(Product.fromJson(v));
    });
  }
}

class Product {
  int? id;
  int? brand_id;
  int? parent_product_id;
  int? isAlternative;
  String? name;
  String? product_barcode;
  String? email;
  String? image;
  String? status;
  String? experience;
  double? hourPrice;
  double? pagePriceExclusive;
  double? translator_rate;
  String? speciality;
  String? mobile;
  String? nationalId;
  String? details;
  String? certificate;
  List<Language>? languages;
  List<Tag>? tags;
  List<Category>? categories;
  Product(
      {this.id,
      this.parent_product_id,
      this.brand_id,
      this.name,
      this.email,
      this.status,
      this.image,
      this.product_barcode,
      this.isAlternative,
      this.certificate,
      this.experience,
      this.hourPrice,
      this.pagePriceExclusive,
      this.speciality,
      this.mobile,
      this.languages,
      this.categories,
      this.translator_rate,
      this.tags,
      this.nationalId,
      this.details});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand_id = json['brand_id'];
    parent_product_id = json['parent_product_id'];
    isAlternative = int.parse(json['isAlternative'].toString());
    name = json['product_name'] ?? "--";
    product_barcode = json['product_barcode'] ?? "";
    email = json['email'];
    image = json['product_image'];
    status = json['status'];
    experience = json['experience'];
    hourPrice = json['page_price'] == null
        ? 0
        : double.tryParse(json['page_price'].toString());
    pagePriceExclusive = json['page_price_exclusive'] == null
        ? 0
        : double.tryParse(json['page_price_exclusive'].toString());
    translator_rate = json['translator_rate'] == null
        ? 0
        : double.tryParse(json['translator_rate'].toString());
    certificate = json['certificate'];
    speciality = json['speciality'];
    mobile = json['mobile'];
    nationalId = json['national_id'];
    details = json['product_decription'] ?? "Not Available";
    if (json['languages'] != null) {
      languages = <Language>[];
      json['languages'].forEach((v) {
        languages!.add(Language.fromJson(v));
      });
    }

    if (json['tags'] != null) {
      tags = <Tag>[];
      json['tags'].forEach((v) {
        tags!.add(Tag.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }
  }
}

class Tag {
  String? text;

  Tag({this.text});
  Tag.fromJson(Map<String, dynamic> json) {
    text = json['tag'];
  }
}
