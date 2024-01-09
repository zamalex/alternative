class ImageSearchReponse {
  List<Responses>? responses;

  ImageSearchReponse({this.responses});

  ImageSearchReponse.fromJson(Map<String, dynamic> json) {
    if (json['responses'] != null) {
      responses = <Responses>[];
      json['responses'].forEach((v) {
        responses!.add(new Responses.fromJson(v));
      });
    }
  }
}

class Responses {
  List<LogoAnnotations>? logoAnnotations;

  Responses({this.logoAnnotations});

  Responses.fromJson(Map<String, dynamic> json) {
    if (json['logoAnnotations'] != null) {
      logoAnnotations = <LogoAnnotations>[];
      json['logoAnnotations'].forEach((v) {
        logoAnnotations!.add(new LogoAnnotations.fromJson(v));
      });
    }
  }
}

class LogoAnnotations {
  String? mid;
  String? description;
  double? score;

  LogoAnnotations({this.mid, this.description, this.score});

  LogoAnnotations.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    description = json['description'];
    score = json['score'];
  }
}
