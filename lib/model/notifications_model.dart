class NotificationsModel {
  int? code;
  String? status;
  String? message;
  Data? data;

  NotificationsModel({this.code, this.status, this.message, this.data});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }


}

class Data {
  int? currentPage;
  List<NotificationData>? data;
  int? total;

  Data(
      {this.currentPage,
        this.data,
        this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
      });
    }
    total = json['total'];
  }


}

class NotificationData {
  int? id;
  int? isSeen;
  String? createdAt;
  String? title;
  String? body;

  NotificationData(
      {this.id,
        this.isSeen,
        this.createdAt,
        this.title,
        this.body,
        });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSeen = json['is_seen'];
    createdAt = json['created_at'];
    title = json['title'];
    body = json['body'];
  }

}
