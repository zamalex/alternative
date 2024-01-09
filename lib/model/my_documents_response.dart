class MyDocumentsResponse {
  int? code;
  String? status;
  String? message;
  Data? data;

  MyDocumentsResponse({this.code, this.status, this.message, this.data});

  MyDocumentsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }


}

class Data {
  List<MyFiles>? myFiles;

  Data({this.myFiles});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['finished_files'] != null) {
      myFiles = <MyFiles>[];
      json['finished_files'].forEach((v) {
        myFiles!.add(new MyFiles.fromJson(v));
      });
    }
  }

}

class MyFiles {
  int? id;
  String? pdf;
  String? name;
  String? created_at;
  int? pagesCount;

  MyFiles(
      {this.id,
        this.pdf,
        this.name,
        this.created_at,
        this.pagesCount,
  });

  MyFiles.fromJson(Map<String, dynamic> json) {
   DateTime date= DateTime.parse(json['created_at'].toString());
    id = json['id'];
    pdf = json['pdf'];
    name = json['name'];
    created_at = '${date.day}/${date.month}/${date.year}';
    pagesCount = json['pages_count'];
  }

}