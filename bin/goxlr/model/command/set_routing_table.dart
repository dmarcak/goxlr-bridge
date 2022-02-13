import '../../goxlr.dart';

class SetRoutingTable {
  String action = 'com.tchelicon.goxlr.routingtable';
  String event = 'keyUp';
  Map<String, Map<String, String>> payload = Map<String, Map<String, String>>();

  SetRoutingTable(InputType input, OutputType output, ActionType action) {
    payload['settings'] = Map<String, String>.from({
      'RoutingAction': _mapAction(action),
      'RoutingInput': _mapInput(input),
      'RoutingOutput': _mapOutput(output)
    });
  }

  Map<String, dynamic> toJson() =>
      {'action': action, 'event': event, 'payload': payload};

  String _mapInput(InputType input) {
    if (input == InputType.LineIn) {
      return 'Line In';
    }

    return input.name;
  }

  String _mapOutput(OutputType output) {
    if (output == OutputType.BroadcastMix) {
      return 'Broadcast Mix';
    }

    if (output == OutputType.ChatMic) {
      return 'Chat Mic';
    }

    if (output == OutputType.LineOut) {
      return 'Line Out';
    }

    return output.name;
  }

  String _mapAction(ActionType action) {
    if (action == ActionType.TurnOff) {
      return 'Turn Off';
    }

    if (action == ActionType.TurnOn) {
      return 'Turn On';
    }

    return action.name;
  }
}
