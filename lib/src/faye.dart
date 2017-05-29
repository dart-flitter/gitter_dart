import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gitter/gitter.dart';
import 'package:gitter/src/models/faye_message.dart';
import 'package:http/http.dart' as http;

class GitterFayeSubscriber {
  final _urlApi = "https://ws.gitter.im/bayeux";
  final _urlWs = "wss://ws.gitter.im/bayeux";
  final String _token;
  final _mapper = <String, List<OnMessage>>{};
  StreamSubscription<List<GitterFayeMessage>> _listener;
  User _user;
  int _id = 1;
  String _clientId;
  WebSocket _socket;
  Stream _socketStream;

  String get clientId => _clientId;
  User get user => _user;

  GitterFayeSubscriber(this._token);

  _handshake() async {
    final handshake = [
      {
        "channel": "/meta/handshake",
        "id": _generateId(),
        "ext": {"token": _token},
        "version": "1.0",
        "supportedConnectionTypes": ["websocket"]
      }
    ];

    final response = await http.post(_urlApi,
        body: "message=${Uri.encodeComponent(JSON.encode(handshake))}",
        headers: {HttpHeaders.CONTENT_TYPE: "text/plain;charset=UTF-8"});
    if (!(response.statusCode >= 200 && response.statusCode < 300)) {
      throw new Exception("Handshake failed, verify your token");
    }
    final message = new GitterFayeMessage.fromJson(
        (JSON.decode(response.body) as List).first);
    _clientId = message.clientId;
    _user = new User.fromJson(message.ext["context"]["user"]);
  }

  String _generateId() => "${_id++}";

  connect() async {
    await _handshake();
    _socket = await WebSocket.connect(_urlWs);
    _socketStream = _socket.asBroadcastStream();
    final message = {
      "channel": "/meta/connect",
      "id": _generateId(),
      "connectionType": "websocket",
      "clientId": clientId,
      "advice": {"timeout": 0}
    };
    _socket.add(JSON.encode(message));
  }

  subscribe(String subscription, [OnMessage handler]) {
    _listener ??= listen(null);

    _mapper[subscription] ??= [];
    if (handler != null) {
      _mapper[subscription].add(handler);
    }

    final message = {
      "channel": "/meta/subscribe",
      "subscription": subscription,
      "clientId": clientId
    };

    _socket.add(JSON.encode(message));
  }

  unsubscribe(String subscription, [OnMessage handler]) {
    if (handler != null) {
      _mapper[subscription].remove(handler);
    }

    final message = {
      "channel": "/meta/unsubscribe",
      "subscription": subscription,
      "clientId": clientId
    };

    _socket.add(JSON.encode(message));
  }

  subscribeToRoom(String roomId, [OnMessage handler]) =>
      subscribe('/api/v1/rooms/$roomId', handler);
  subscribeToChatMessages(String roomId, [OnMessage handler]) =>
      subscribe('/api/v1/rooms/$roomId/chatMessages', handler);
  subscribeToRoomEvents(String roomId, [OnMessage handler]) =>
      subscribe('/api/v1/rooms/$roomId/events', handler);
  subscribeToRoomUsers(String roomId, [OnMessage handler]) =>
      subscribe('/api/v1/rooms/$roomId/users', handler);
  subscribeToUser(String userId, [OnMessage handler]) =>
      subscribe("/api/v1/user/$userId", handler);
  subscribeToUserRooms(String userId, [OnMessage handler]) =>
      subscribe("/api/v1/user/$userId/rooms", handler);
  subscribeToUserRoomUnreadItems(String roomId, String userId, [OnMessage handler]) =>
      subscribe("/api/v1/user/$userId/rooms/$roomId/unreadItems", handler);

  _dispatch(List<GitterFayeMessage> events, OnMessage onData) {
    final _mapping = <String, List<GitterFayeMessage>>{};
    events.forEach((GitterFayeMessage msg) {
      _mapping[msg.subscription] ??= [];
      _mapping[msg.subscription].add(msg);
    });
    if (_mapping.isNotEmpty) {
      _mapping.forEach((String subscription, events) {
        _mapper[subscription]?.forEach((handler) {
          handler(events);
        });
      });
    }
    if (onData != null) {
      onData(events);
    }
  }

  StreamSubscription<List<GitterFayeMessage>> listen(OnMessage onData,
          {Function onError, void onDone(), bool cancelOnError}) =>
      _socketStream.listen((data) {
        final decode = JSON.decode(data);
        if (decode is Iterable) {
          _dispatch(
              decode.map((d) => new GitterFayeMessage.fromJson(d)).toList(),
              onData);
        } else {
          _dispatch([new GitterFayeMessage.fromJson(decode)], onData);
        }
      }, onDone: onDone, cancelOnError: cancelOnError);

  close() {
    _socket.close();
    _listener.cancel();
  }
}

typedef void OnMessage(List<GitterFayeMessage> event);

class GitterFayeNotifications {
  static const String unreadItems = "unread_items"; // data: { notification: "unread_items", items: {} }, ext: { c: COUNT } }
  static const String unreadItemsRemoved = "unread_items_removed";
}