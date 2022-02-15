import 'goxlr.dart';

class DataMapper {
  static String mapInputToGoXLRValue(InputType input) {
    if (input == InputType.LineIn) {
      return 'Line In';
    }

    return input.name;
  }

  static String mapOutputToGoXLRValue(OutputType output) {
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

  static String mapActionToGoXLRValue(ActionType action) {
    if (action == ActionType.TurnOff) {
      return 'Turn Off';
    }

    if (action == ActionType.TurnOn) {
      return 'Turn On';
    }

    return action.name;
  }

  static InputType mapStringToInput(String value) {
    return InputType.values
        .firstWhere((e) => e.toString() == 'InputType.' + value);
  }

  static OutputType mapStringToOutput(String value) {
    return OutputType.values
        .firstWhere((e) => e.toString() == 'OutputType.' + value);
  }

  static ActionType mapStringToAction(String value) {
    return ActionType.values
        .firstWhere((e) => e.toString() == 'ActionType.' + value);
  }
}
