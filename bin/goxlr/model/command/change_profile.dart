class ChangeProfile {
  String action = 'com.tchelicon.goxlr.profilechange';
  String event = 'keyUp';
  Map<String, Map<String, String>> payload;

  ChangeProfile(String name) : payload = Map<String, Map<String, String>>() {
    payload['settings'] = Map<String, String>.from({'SelectedProfile': name});
  }

  Map<String, dynamic> toJson() =>
      {'action': action, 'event': event, 'payload': payload};
}
