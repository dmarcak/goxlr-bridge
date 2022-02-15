import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'request.dart';

class GoXLRConnection {
  final WebSocketChannel _connection;

  GoXLRConnection(this._connection);

  void dispatch(Request command) {
    _connection.sink.add(jsonEncode(command));
  }
}
