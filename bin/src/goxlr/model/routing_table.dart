import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';

import '../data_mapper.dart';
import '../goxlr.dart';

class RoutingTable {
  final InputType _input;
  final OutputType _output;
  final ActionType _action;

  RoutingTable(this._input, this._output, this._action);

  InputType get input => _input;
  OutputType get output => _output;
  ActionType get action => _action;

  static FutureOr<RoutingTable> createFromRequest(Request request) async {
    var payload = jsonDecode(await request.readAsString());
    var input = DataMapper.mapStringToInput(payload['input']);
    var output = DataMapper.mapStringToOutput(payload['output']);
    var action = DataMapper.mapStringToAction(payload['action']);

    return RoutingTable(input, output, action);
  }
}
