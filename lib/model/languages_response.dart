class Language {
  int? id;
  String? code;
  String? name;

  Language(
      {this.id,
        this.code,
        this.name,
  });

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];

  }

}
