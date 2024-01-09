class SlidersResponse {
  int? code;
  List<Data>? data;

  SlidersResponse({this.code, this.data});

  SlidersResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }


}

class Data {
  String? image;
  String? url;

  Data({this.image, this.url});

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    url = json['url'];
  }

}