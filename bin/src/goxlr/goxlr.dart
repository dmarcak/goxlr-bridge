import 'model/profile.dart';
import 'request/fetch_profiles.dart';
import 'request/set_profile.dart';
import 'request/set_routing_table.dart';
import 'connection.dart';
import 'model/routing_table.dart';
import 'message/goxlr_message.dart';

// ignore: constant_identifier_names
enum InputType { Mic, Chat, Music, Game, Console, LineIn, System, Samples }

// ignore: constant_identifier_names
enum OutputType { Headphones, BroadcastMix, LineOut, ChatMic, Sampler }

// ignore: constant_identifier_names
enum ActionType { TurnOn, TurnOff, Toggle }

class GoXLR {
  GoXLRConnection connection;

  List<String> profiles = List.empty(growable: true);

  GoXLR(this.connection);

  void update(Map<String, dynamic> payload) {
    try {
      var message = GoXLRMessageFactory.createFromPayload(payload);

      if (message is GoXLRConnectionEventMessage) {
        return fetchProfiles();
      }

      if (message is SendToPropertyInspectorMessage) {
        profiles = message.profiles;
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  void fetchProfiles() {
    connection.dispatch(FetchProfiles());
  }

  void setProfile(Profile profile) {
    if (!profiles.contains(profile.name)) {
      throw Exception('There is no profile named ${profile.name}');
    }

    connection.dispatch(SetProfile(profile.name));
  }

  void setRoutingTable(RoutingTable table) {
    connection
        .dispatch(SetRoutingTable(table.input, table.output, table.action));
  }
}
