class GoXLRMessage {
  String action;
  String context;
  String event;

  GoXLRMessage(this.action, this.context, this.event);

  factory GoXLRMessage.fromJson(dynamic json) {
    String event = json['event'] as String;

    switch (event) {
      case 'goxlrConnectionEvent':
        return GoXLRConnectionEvent(json['device'] as String, event);
      case 'sendToPropertyInspector':
        return ProfileList(json['action'] as String, event, json['payload']);
      case 'getSettings':
        return GetSettings(json['action'] as String, event);
      default:
        throw Exception('Invalid event type: $event');
    }
  }
}

class GoXLRConnectionEvent extends GoXLRMessage {
  String device;

  GoXLRConnectionEvent(this.device, String event) : super('', '', event) {}
}

class ProfileList extends GoXLRMessage {
  List<String> profiles;

  ProfileList(String action, String event, Map<String, dynamic> payload)
      : profiles = List.from(
            payload['Profiles'].map((dynamic element) => element as String)),
        super(action, '', event) {}
}

class GetSettings extends GoXLRMessage {
  GetSettings(String action, String event) : super(action, '', event);
}
