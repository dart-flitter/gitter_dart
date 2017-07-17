library gitter.faye_message;

class GitterFayeMessage {
  String id;
  String clientId;
  String channel;
  String subscription;
  bool successful;
  Map<String, dynamic> advice;
  Map<String, dynamic> data;
  Map<String, dynamic> ext;

  GitterFayeMessage();

  static Map toMap(GitterFayeMessage model) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.clientId != null) {
        ret["clientId"] = model.clientId;
      }
      if (model.channel != null) {
        ret["channel"] = model.channel;
      }
      if (model.subscription != null) {
        ret["subscription"] = model.subscription;
      }
      if (model.successful != null) {
        ret["successful"] = model.successful;
      }
      if (model.advice != null) {
        ret["advice"] = model.advice;
      }
      if (model.data != null) {
        ret["data"] = model.data;
      }
      if (model.ext != null) {
        ret["ext"] = model.ext;
      }
    }
    return ret;
  }

  static GitterFayeMessage fromMap(Map map) {
    if (map == null) return null;
    GitterFayeMessage model = new GitterFayeMessage();
    model.id = map["id"];
    model.clientId = map["clientId"];
    model.channel = map["channel"];
    model.subscription = map["subscription"];
    model.successful = map["successful"];
    model.advice = map["advice"];
    model.data = map["data"];
    model.ext = map["ext"];
    return model;
  }

  factory GitterFayeMessage.fromJson(Map<String, dynamic> json) =>
      fromMap(json);

  @override
  String toString() => toMap(this).toString();
}
