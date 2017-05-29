import 'package:gitter/src/faye.dart';
import 'package:gitter/src/models/faye_message.dart';

const token = const String.fromEnvironment("TOKEN");
const roomId = const String.fromEnvironment("ROOM_ID");

main() async {
  GitterFayeSubscriber subscriber = new GitterFayeSubscriber(token);
  await subscriber.connect();

  final messageHandler = (List<GitterFayeMessage> msgs) {
    msgs.forEach((GitterFayeMessage msg) {
      print(msg);
    });
  };

  subscriber.subscribeToRoom(roomId);
  subscriber.subscribeToChatMessages(roomId);
  subscriber.subscribeToRoomEvents(roomId);
  subscriber.subscribeToRoomUsers(roomId);
  subscriber.subscribeToUser(subscriber.user.id);
  subscriber.subscribeToUserRoomUnreadItems(roomId, subscriber.user.id);

  subscriber.listen(messageHandler);
}
