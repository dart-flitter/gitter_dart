library gitter.faye_message;

import 'package:jaguar_serializer/serializer.dart';

part 'faye_message.g.dart';

@GenSerializer()
class GitterFayeMessageSerializer extends Serializer<GitterFayeMessage>
    with _$GitterFayeMessageSerializer {
  @override
  GitterFayeMessage createModel() => new GitterFayeMessage();
}

class GitterFayeMessage {
  static final serializer = new GitterFayeMessageSerializer();

  String id;
  String clientId;
  String channel;
  String subscription;
  bool successful;
  Map<String, dynamic> advice;
  Map<String, dynamic> data;
  Map<String, dynamic> ext;

  GitterFayeMessage();

  factory GitterFayeMessage.fromJson(Map<String, dynamic> json) =>
      serializer.fromMap(json);

  @override
  String toString() => serializer.toMap(this).toString();
}
