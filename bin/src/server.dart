import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'goxlr/connection.dart';
import 'goxlr/goxlr.dart';
import 'manager.dart';

class Server {
  final Logger _logger;
  final GoXLRManager _goXLRManager;
  final String _host;
  final int _port;
  final Router _router;

  Server(this._logger, this._goXLRManager,
      {String host = '0.0.0.0', int port = 6805})
      : _host = host,
        _port = port,
        _router = Router();

  Server add(String verb, String route, Function handler) {
    _router.add(verb, route, handler);
    return this;
  }

  void listen(Function(dynamic value) onValue, {Function? onError}) {
    var handler =
        Pipeline().addMiddleware(_requestLogger()).addHandler(_requestHandler);

    serve(handler, _host, _port).then(onValue, onError: onError);
  }

  void _onWebSocketData(dynamic data) {
    _logger.fine('Received websocket payload: $data');
    _goXLRManager.goXLR.update(jsonDecode(data.toString()));
  }

  FutureOr<Response> _webSocketHandler(Request request) =>
      webSocketHandler((WebSocketChannel webSocket) {
        _logger.fine('WebSocket client connected.');

        _goXLRManager.set(GoXLR(GoXLRConnection(webSocket), _logger));
        webSocket.stream.listen(_onWebSocketData, onDone: _goXLRManager.remove);
      })(request);

  FutureOr<Response> _requestHandler(Request request) async {
    var query = request.url.query;
    var upgradeHeader = request.headers['upgrade'];

    if (query == 'GOXLRApp' && upgradeHeader == 'websocket') {
      return await _webSocketHandler(request);
    }

    return _router(request);
  }

  Middleware _requestLogger() => (innerHandler) {
        return (request) {
          return Future.sync(() => innerHandler(request)).then((response) {
            _logger.fine(
                '${request.method.padRight(7)} [${response.statusCode}] ${request.requestedUri.path}');

            return response;
          }, onError: (Object error, StackTrace stackTrace) {
            if (error is HijackException) throw error;

            _logger.warning(
                '${request.method.padRight(7)} ${request.requestedUri.path}\n$error');

            throw error;
          });
        };
      };
}
