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
  var _timeout = 120000;
  Timer _timeoutTimer;

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

  String _generateId() {
    if (_id < 0) _id = 0;
    return "${_id++}";
  }

  _initListener() {
    _listener ??= _listen((_) {
      _timeoutTimer?.cancel();
      _timeoutTimer =
      new Timer(new Duration(milliseconds: _timeout - 1000), _connect);
    });
  }

  connect({bool keepAlive: true}) async {
    await _handshake();
    _listener?.cancel();
    _listener = null;
    _socket = await WebSocket.connect(_urlWs);
    _socketStream = _socket.asBroadcastStream();

    _initListener();

    final res = await _connect();
    _timeout = res.advice["timeout"];
    _timeoutTimer?.cancel();
    if (keepAlive) {
      _timeoutTimer =
          new Timer(new Duration(milliseconds: _timeout - 1000), _connect);
    }
  }

  Future<GitterFayeMessage> _connect() async {
    final message = {
      "connectionType": "websocket",
      "advice": {"timeout": 0}
    };
    final channel = "/meta/connect";

    final completer = new Completer<GitterFayeMessage>();

    _send(channel, message, (List<GitterFayeMessage> messages) {
      for (GitterFayeMessage msg in messages) {
        if (msg.successful == true) {
          if (completer.isCompleted == false) {
            completer.complete(msg);
          }
          _mapper[msg.channel] = [];
        } else if (msg.successful == false) {
            throw new Exception("'connect' failed");
        }
      }
    });
    return completer.future;
  }

  _send(String channel, Map<String, dynamic> message, [OnMessage onResponse]) {
    _mapper[channel] ??= [];
    if (onResponse != null) {
      _mapper[channel].add(onResponse);
    }

    message ??= {};
    message["clientId"] = clientId;
    message["channel"] = channel;
    message["id"]=  _generateId();

    _socket.add(JSON.encode(message));
  }

  subscribe(String subscription, [OnMessage handler]) {
    _initListener();
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

  unsubscribeToChatMessages(String roomId, [OnMessage handler]) =>
      unsubscribe('/api/v1/rooms/$roomId/chatMessages', handler);

  subscribeToRoomEvents(String roomId, [OnMessage handler]) =>
      subscribe('/api/v1/rooms/$roomId/events', handler);

  subscribeToRoomUsers(String roomId, [OnMessage handler]) =>
      subscribe('/api/v1/rooms/$roomId/users', handler);

  subscribeToUser(String userId, [OnMessage handler]) =>
      subscribe("/api/v1/user/$userId", handler);

  subscribeToUserRooms(String userId, [OnMessage handler]) =>
      subscribe("/api/v1/user/$userId/rooms", handler);

  subscribeToUserRoomUnreadItems(String roomId, String userId,
          [OnMessage handler]) =>
      subscribe("/api/v1/user/$userId/rooms/$roomId/unreadItems", handler);

  _dispatch(List<GitterFayeMessage> events) {
    final _mapping = <String, List<GitterFayeMessage>>{};
    events.forEach((GitterFayeMessage msg) {
      _mapping[msg.subscription ?? msg.channel] ??= [];
      _mapping[msg.subscription ?? msg.channel].add(msg);
    });
    if (_mapping.isNotEmpty) {
      _mapping.forEach((String subscription, events) {
        if (_mapper[subscription]?.isNotEmpty) {
          final list = new List.from(_mapper[subscription]);
          list.forEach((handler) {
            handler(events);
          });
        }
      });
    }
  }

  StreamSubscription<List<GitterFayeMessage>> _listen(OnMessage onData,
          {Function onError,
          void onDone(),
          bool cancelOnError,
          bool dispatch: true}) =>
      _socketStream.listen((data) {
        final decode = JSON.decode(data);
        var messages;
        if (decode is Iterable) {
          messages =
              decode.map((d) => new GitterFayeMessage.fromJson(d)).toList();
        } else {
          messages = [new GitterFayeMessage.fromJson(decode)];
        }
        if (dispatch) {
          _dispatch(messages);
        }
        if (onData != null) {
          onData(messages);
        }
      }, onDone: onDone, cancelOnError: cancelOnError);

  close() {
    _socket.close();
    _listener.cancel();
  }

  bool get isClose => _socket.closeCode != null;
}

typedef void OnMessage(List<GitterFayeMessage> event);

class GitterFayeNotifications {
  static const String unreadItems =
      "unread_items"; // data: { notification: "unread_items", items: {} }, ext: { c: COUNT } }
  static const String unreadItemsRemoved = "unread_items_removed";
}
