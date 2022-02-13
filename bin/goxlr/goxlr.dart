import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import 'model/command/change_profile.dart';
import 'model/command/fetch_profiles.dart';
import 'model/command/set_routing_table.dart';
import 'model/response/goxlr_message.dart';

enum InputType { Mic, Chat, Music, Game, Console, LineIn, System, Samples }
enum OutputType { Headphones, BroadcastMix, LineOut, ChatMic, Sampler }
enum ActionType { TurnOn, TurnOff, Toggle }

class GoXLR {
  WebSocketChannel? _channel;

  List<String> profiles = List.empty(growable: true);

  GoXLR({String host = '0.0.0.0', int port = 6805}) {
    var handler = webSocketHandler((WebSocketChannel channel) {
      _channel = channel;

      channel.stream.listen((event) async {
        try {
          GoXLRMessage message = GoXLRMessage.fromJson(jsonDecode(event));

          if (message is GoXLRConnectionEvent) {
            channel.sink.add(jsonEncode((FetchProfiles().toJson())));
          } else if (message is ProfileList) {
            profiles = message.profiles;
          }
        } catch (_) {
          print(_.toString());
        }
      }, onError: (Object error, StackTrace stackTrace) {
        print(error);
      }, onDone: () {});
    });

    shelf_io.serve(handler, host, port).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });
  }

  WebSocketChannel ensureWs() {
    var channel = _channel;
    if (channel == null) throw StateError("Channel not available");
    return channel;
  }

  void setProfile(String name) {
    if (!profiles.contains(name)) {
      throw Exception('There is no profile named $name');
    }

    ensureWs().sink.add(jsonEncode(ChangeProfile(name)));
  }

  void setRoutingTable(InputType input, OutputType output, ActionType action) {
    ensureWs().sink.add(jsonEncode(SetRoutingTable(input, output, action)));
  }
}
