import 'package:gitter/src/faye.dart';
import 'package:gitter/src/models/faye_message.dart';

const token =
    "c18d06c5bcadf6335c9d5d594b61c7883b433803"; // ?? const String.fromEnvironment("TOKEN");
const roomId =
    "57aa693540f3a6eec05eb1d5"; //const String.fromEnvironment("ROOM_ID");

main() async {
  GitterFayeSubscriber subscriber = new GitterFayeSubscriber(token);
  await subscriber.connect();

  final messageHandler = (List<GitterFayeMessage> msgs) {
    msgs.forEach((GitterFayeMessage msg) {
      print(msg);
    });
  };

  //subscriber.subscribeToRoom(roomId);
  //subscriber.subscribeToChatMessages(roomId);
  //subscriber.subscribeToRoomEvents(roomId);
  //subscriber.subscribeToRoomUsers(roomId);
  //subscriber.subscribeToUser(subscriber.user.id);
  subscriber.subscribeToUserRoomUnreadItems(roomId, subscriber.user.id);

  subscriber.listen(messageHandler);
}