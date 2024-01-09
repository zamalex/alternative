class GlobalResponse {
  List<GlobalProduct>? products;

  GlobalResponse({this.products});

  GlobalResponse.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <GlobalProduct>[];
      json['products'].forEach((v) {
        products!.add(new GlobalProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GlobalProduct {
  String? brands;
  String? code;
  String? countries;
  String? imageUrl;
  String? productName;

  GlobalProduct(
      {this.brands,
      this.code,
      this.countries,
      this.imageUrl,
      this.productName});

  GlobalProduct.fromJson(Map<String, dynamic> json) {
    brands = json['brands'];
    code = json['code'];
    countries = json['countries'];
    imageUrl = json['image_url'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brands'] = this.brands;
    data['code'] = this.code;
    data['countries'] = this.countries;
    data['image_url'] = this.imageUrl;
    data['product_name'] = this.productName;
    return data;
  }
}
