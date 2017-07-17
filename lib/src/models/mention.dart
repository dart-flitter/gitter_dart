library gitter.mentions;

class Mention {
  String screenName;
  String userId;

  Mention();

  factory Mention.fromJson(Map<String, String> json) =>
      Mention.fromMap(json);

  @override
  String toString() => Mention.toMap(this).toString();

  static Map toMap(Mention model) {
    Map ret = new Map();
    if (model != null) {
      if (model.screenName != null) {
        ret["screenName"] = model.screenName;
      }
      if (model.userId != null) {
        ret["userId"] = model.userId;
      }
    }
    return ret;
  }

  static Mention fromMap(Map map) {
    if (map == null) return null;
    Mention model = new Mention();
    model.screenName = map["screenName"];
    model.userId = map["userId"];
    return model;
  }
}
