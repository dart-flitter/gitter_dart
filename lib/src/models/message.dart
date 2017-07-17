library gitter.message;

import 'package:gitter/gitter.dart';

class DateTimeProcessor {
  static String serialize(DateTime value) => value?.toIso8601String();

  static DateTime deserialize(String value) =>
      value != null ? DateTime.parse(value) : null;
}

class Message {
  String id;
  String text;
  String html;
  DateTime sent;
  DateTime editedAt;
  User fromUser;
  bool unread;
  int readBy;
  List<Map<String, String>> urls;
  List<Mention> mentions;
  List<Issue> issues;

//  not used right now
//  final meta;
  int v;

//  final gv;

  Message();

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message.fromMap(json);

  @override
  String toString() => Message.toMap(this).toString();

  static Map toMap(Message model) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.text != null) {
        ret["text"] = model.text;
      }
      if (model.html != null) {
        ret["html"] = model.html;
      }
      if (model.sent != null) {
        ret["sent"] = DateTimeProcessor.serialize(model.sent);
      }
      if (model.editedAt != null) {
        ret["editedAt"] = DateTimeProcessor.serialize(model.editedAt);
      }
      if (model.fromUser != null) {
        ret["fromUser"] = User.toMap(model.fromUser);
      }
      if (model.unread != null) {
        ret["unread"] = model.unread;
      }
      if (model.readBy != null) {
        ret["readBy"] = model.readBy;
      }
      if (model.urls != null) {
        ret["urls"] = model.urls;
      }
      if (model.mentions != null) {
        ret["mentions"] = model.mentions
            ?.map((Mention val) =>
        val != null
            ? Mention.toMap(val)
            : null)
            ?.toList();
      }
      if (model.issues != null) {
        ret["issues"] = model.issues
            ?.map((Issue val) =>
        val != null
            ? Issue.toMap(val)
            : null)
            ?.toList();
      }
      if (model.v != null) {
        ret["v"] = model.v;
      }
    }
    return ret;
  }

  static Message fromMap(Map map) {
    if (map == null) return null;
    Message model = new Message();
    model.id = map["id"];
    model.text = map["text"];
    model.html = map["html"];
    model.sent = DateTimeProcessor.deserialize(map["sent"]);
    model.editedAt = DateTimeProcessor.deserialize(map["editedAt"]);
    model.fromUser =
        User.fromMap(map["fromUser"]);
    model.unread = map["unread"];
    model.readBy = map["readBy"];
    model.urls = map["urls"];
    ;
    model.mentions = map["mentions"]
        ?.map((Map val) => Mention.fromMap(val))
        ?.toList();
    model.issues = map["issues"]
        ?.map((Map val) => Issue.fromMap(val))
        ?.toList();
    model.v = map["v"];
    return model;
  }
}
