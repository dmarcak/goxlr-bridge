import '../request.dart';

class SetProfile implements Request {
  final String name;

  SetProfile(this.name);

  @override
  Map<String, dynamic> toJson() {
    return {
      'action': 'com.tchelicon.goxlr.profilechange',
      'event': 'keyUp',
      'payload': {
        'settings': {'SelectedProfile': name}
      }
    };
  }
}
