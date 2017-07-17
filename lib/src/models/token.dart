library gitter.token;

import 'package:gitter/src/oauth/oauth.dart';

class GitterToken implements Token {
  @override
  String access;

  @override
  String type;

  GitterToken();

  factory GitterToken.fromJson(Map<String, String> json) =>
      GitterToken.fromMap(json);

  Map toMap() => GitterToken.toJsonMap(this);

  @override
  String toString() => GitterToken.toJsonMap(this).toString();

  static Map toJsonMap(GitterToken model) {
    Map ret = new Map();
    if (model != null) {
      if (model.access != null) {
        ret["access_token"] = model.access;
      }
      if (model.type != null) {
        ret["token_type"] = model.type;
      }
    }
    return ret;
  }

  static GitterToken fromMap(Map map) {
    if (map == null) return null;
    GitterToken model = new GitterToken();
    model.access = map["access_token"];
    model.type = map["token_type"];
    return model;
  }

}
