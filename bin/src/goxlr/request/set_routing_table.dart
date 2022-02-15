import '../request.dart';
import '../goxlr.dart';
import '../data_mapper.dart';

class SetRoutingTable implements Request {
  final InputType input;
  final OutputType output;
  final ActionType action;

  SetRoutingTable(this.input, this.output, this.action);

  @override
  Map<String, dynamic> toJson() {
    return {
      'action': 'com.tchelicon.goxlr.routingtable',
      'event': 'keyUp',
      'payload': {
        'settings': {
          'RoutingInput': DataMapper.mapInputToGoXLRValue(input),
          'RoutingOutput': DataMapper.mapOutputToGoXLRValue(output),
          'RoutingAction': DataMapper.mapActionToGoXLRValue(action)
        }
      }
    };
  }
}
