class UploadResponse {
  UploadResponse({
     this.code,
     this.status,
     this.message,
     this.data,
  });
  int? code;
  String? status;
  String? message;
  UploadData? data;

  UploadResponse.fromJson(Map<String, dynamic> json){
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = UploadData.fromJson(json['data']);
  }

}

class UploadData {
  UploadData({
     this.name,
     this.pdf,
     this.id,
     this.pagesCount,
  });
    String? name;
    String? pdf;
    int? id;
    int? pagesCount;

  UploadData.fromJson(Map<String, dynamic> json){
    name = json['name'];
    pdf = json['pdf'];
    id = json['id'];
    pagesCount = json['pages_count'];
  }


}