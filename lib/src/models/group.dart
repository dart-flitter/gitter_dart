library gitter.group;

class Group {
  String id;
  String name;
  String uri;
  SecurityDescriptor backedBy;
  String avatarUrl;

  Group();

  factory Group.fromJson(Map<String, dynamic> json) => Group.fromMap(json);

  @override
  String toString() => Group.toMap(this).toString();

  static Map toMap(Group model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.name != null) {
        ret["name"] = model.name;
      }
      if (model.uri != null) {
        ret["uri"] = model.uri;
      }
      if (model.backedBy != null) {
        ret["backedBy"] = SecurityDescriptor.toMap(model.backedBy);
      }
      if (model.avatarUrl != null) {
        ret["avatarUrl"] = model.avatarUrl;
      }
    }
    return ret;
  }

  static Group fromMap(Map map) {
    if (map == null) return null;
    Group model = new Group();
    model.id = map["id"];
    model.name = map["name"];
    model.uri = map["uri"];
    model.backedBy = SecurityDescriptor.fromMap(map["backedBy"]);
    model.avatarUrl = map["avatarUrl"];
    return model;
  }

}

class SecurityDescriptor {
  String type;
  String linkPath;

  SecurityDescriptor();

  factory SecurityDescriptor.fromJson(Map<String, dynamic> json) =>
      SecurityDescriptor.fromMap(json);

  @override
  String toString() => SecurityDescriptor.toMap(this).toString();

  static Map toMap(SecurityDescriptor model) {
    Map ret = new Map();
    if (model != null) {
      if (model.type != null) {
        ret["type"] = model.type;
      }
      if (model.linkPath != null) {
        ret["linkPath"] = model.linkPath;
      }
    }
    return ret;
  }

  static SecurityDescriptor fromMap(Map map) {
    SecurityDescriptor model = new SecurityDescriptor();
    model.type = map["type"];
    model.linkPath = map["linkPath"];
    return model;
  }
}
