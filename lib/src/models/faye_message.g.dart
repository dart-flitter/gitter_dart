// GENERATED CODE - DO NOT MODIFY BY HAND

part of gitter.faye_message;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class GitterFayeMessageSerializer
// **************************************************************************

abstract class _$GitterFayeMessageSerializer
    implements Serializer<GitterFayeMessage> {
  final RawData adviceRawData = const RawData(#advice);
  final RawData dataRawData = const RawData(#data);
  final RawData extRawData = const RawData(#ext);

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
      if (model.successful != null) {
        ret["successful"] = model.successful;
      }
      if (model.advice != null) {
        ret["advice"] = adviceRawData.serialize(model.advice);
      }
      if (model.data != null) {
        ret["data"] = dataRawData.serialize(model.data);
      }
      if (model.ext != null) {
        ret["ext"] = extRawData.serialize(model.ext);
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
    model.successful = map["successful"];
    model.advice = adviceRawData.deserialize(map["advice"]);
    model.data = dataRawData.deserialize(map["data"]);
    model.ext = extRawData.deserialize(map["ext"]);
    return model;
  }

  String modelString() => "GitterFayeMessage";
}
