library gitter.room;

import 'package:gitter/gitter.dart';


class Room {
  String id;
  String name;
  String topic;
  String uri;
  bool oneToOne;
  num userCount;
  User user;
  num unreadItems = 0;
  num mentions = 0;
  String lastAccessTime;
  bool lurk;
  String url;
  String githubType;
  List<String> tags;
  num v;
  String avatarUrl;

  Room();

  factory Room.fromJson(Map<String, dynamic> json) => Room.fromMap(json);

  @override
  String toString() => Room.toMap(this).toString();

  static Map toMap(Room model) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.name != null) {
        ret["name"] = model.name;
      }
      if (model.topic != null) {
        ret["topic"] = model.topic;
      }
      if (model.uri != null) {
        ret["uri"] = model.uri;
      }
      if (model.oneToOne != null) {
        ret["oneToOne"] = model.oneToOne;
      }
      if (model.userCount != null) {
        ret["userCount"] = model.userCount;
      }
      if (model.user != null) {
        ret["user"] = User.toMap(model.user);
      }
      if (model.unreadItems != null) {
        ret["unreadItems"] = model.unreadItems;
      }
      if (model.mentions != null) {
        ret["mentions"] = model.mentions;
      }
      if (model.lastAccessTime != null) {
        ret["lastAccessTime"] = model.lastAccessTime;
      }
      if (model.lurk != null) {
        ret["lurk"] = model.lurk;
      }
      if (model.url != null) {
        ret["url"] = model.url;
      }
      if (model.githubType != null) {
        ret["githubType"] = model.githubType;
      }
      if (model.tags != null) {
        ret["tags"] =
            model.tags?.map((String val) => val != null ? val : null)?.toList();
      }
      if (model.v != null) {
        ret["v"] = model.v;
      }
      if (model.avatarUrl != null) {
        ret["avatarUrl"] = model.avatarUrl;
      }
    }
    return ret;
  }

  static Room fromMap(Map map) {
    if (map == null) return null;
    Room model = new Room();
    model.id = map["id"];
    model.name = map["name"];
    model.topic = map["topic"];
    model.uri = map["uri"];
    model.oneToOne = map["oneToOne"];
    model.userCount = map["userCount"];
    model.user = User.fromMap(map["user"]);
    model.unreadItems = map["unreadItems"];
    model.mentions = map["mentions"];
    model.lastAccessTime = map["lastAccessTime"];
    model.lurk = map["lurk"];
    model.url = map["url"];
    model.githubType = map["githubType"];
    model.tags = map["tags"]?.map((String val) => val)?.toList();
    model.v = map["v"];
    model.avatarUrl = map["avatarUrl"];
    return model;
  }
}
