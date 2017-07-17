library gitter.issue;

class Issue {
  String number;

  Issue();

  factory Issue.fromJson(Map<String, String> json) => Issue.fromMap(json);

  @override
  String toString() => Issue.toMap(this).toString();

  static Map toMap(Issue model) {
    Map ret = new Map();
    if (model != null) {
      if (model.number != null) {
        ret["number"] = model.number;
      }
    }
    return ret;
  }

  static Issue fromMap(Map map) {
    if (map == null) return null;
    Issue model = new Issue();
    model.number = map["number"];
    return model;
  }

}
