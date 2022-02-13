import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'dart:convert';

import '../goxlr/goxlr.dart';

class Api {
  GoXLR goXLR;

  Api(this.goXLR, {String host = '0.0.0.0', int port = 80}) {
    var app = Router();

    app.get('/status', (Request request) {
      return Response.ok('');
    });

    app.get('/profile', (Request request) {
      try {
        var json = jsonEncode(goXLR.profiles);
        return Response.ok(json, headers: {'Content-Type': 'application/json'});
      } catch (_) {
        print(_.toString());
        return Response(400, body: '{"status": "error"}');
      }
    });

    app.post('/profile', (Request request) async {
      try {
        var data =
            jsonDecode(await request.readAsString()) as Map<String, dynamic>;

        goXLR.setProfile(data['name'] as String);

        return Response.ok('{"status": "ok"}');
      } catch (_) {
        print(_.toString());
        return Response(400, body: '{"status": "error"}');
      }
    });

    app.post('/routing-table', (Request request) async {
      try {
        var data =
            jsonDecode(await request.readAsString()) as Map<String, dynamic>;

        var input = InputType.values
            .firstWhere((e) => e.toString() == 'InputType.' + data['input']);
        var output = OutputType.values
            .firstWhere((e) => e.toString() == 'OutputType.' + data['output']);
        var action = ActionType.values
            .firstWhere((e) => e.toString() == 'ActionType.' + data['action']);

        goXLR.setRoutingTable(input, output, action);

        return Response.ok('{"status": "ok"}');
      } catch (_) {
        print(_);
        return Response(400, body: '{"status": "error"}');
      }
    });

    shelf_io.serve(app, host, port).then((server) {
      print('Serving at http://${server.address.host}:${server.port}');
    });
  }
}
