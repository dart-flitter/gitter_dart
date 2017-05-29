// GENERATED CODE - DO NOT MODIFY BY HAND

part of gitter.faye_message;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class GitterFayeMessageSerializer
// **************************************************************************

abstract class _$GitterFayeMessageSerializer
    implements Serializer<GitterFayeMessage> {
  Map toMap(GitterFayeMessage model, {bool withType: false, String typeKey}) {
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
      if (model.data != null) {
        ret["data"] = model.data;
      }
      if (model.ext != null) {
        ret["ext"] = model.ext;
      }
      if (modelString() != null && withType) {
        ret[typeKey ?? defaultTypeInfoKey] = modelString();
      }
    }
    return ret;
  }

  GitterFayeMessage fromMap(Map map,
      {GitterFayeMessage model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! GitterFayeMessage) {
      model = createModel();
    }
    model.id = map["id"];
    model.clientId = map["clientId"];
    model.channel = map["channel"];
    model.subscription = map["subscription"];
    model.data = map["data"];
    model.ext = map["ext"];
    return model;
  }

  String modelString() => "GitterFayeMessage";
}
