import 'dart:math';

import 'package:logging/logging.dart';

import 'exception.dart';
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
  Logger _logger;
  GoXLRConnection _connection;

  List<String> profiles = List.empty(growable: true);

  GoXLR(this._connection, this._logger);

  void update(Map<String, dynamic> payload) {
    try {
      var message = GoXLRMessageFactory.createFromPayload(payload);

      if (message is GoXLRConnectionEventMessage) {
        return fetchProfiles();
      }

      if (message is SendToPropertyInspectorMessage) {
        profiles = message.profiles;
      }
    } on UnsupportedEvent catch (exception) {
      _logger.warning('Unsupported event received from GoXLR.', exception);
    } on InvalidMessage catch (exception) {
      _logger.severe('Invalid message from GoXLR.', exception);
    } catch (exception) {
      _logger.shout(
          'An error ocurred while processing GoXLR Message.', exception);
    }
  }

  void fetchProfiles() {
    _connection.dispatch(FetchProfiles());
  }

  void setProfile(Profile profile) {
    if (!profiles.contains(profile.name)) {
      throw ProfileNotFound(profile.name);
    }

    _connection.dispatch(SetProfile(profile.name));
  }

  void setRoutingTable(RoutingTable table) {
    _connection
        .dispatch(SetRoutingTable(table.input, table.output, table.action));
  }
}
