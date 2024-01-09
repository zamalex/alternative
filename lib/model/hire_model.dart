class HireModel {
  int? code;
  String? status;
  String? message;
  Data? data;

  HireModel({this.code, this.status, this.message, this.data});

  HireModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

}

class Data {
  int? id;
  int? total;
  String? transactionNo;
  String? paymentUrl;
  String? firebaseId;

  Data(
      {this.id,
        this.total,
        this.transactionNo,
        this.paymentUrl,
        this.firebaseId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    transactionNo = json['transactionNo'];
    paymentUrl = json['payment_url'];
    firebaseId = json['firebase_id'];
  }

}