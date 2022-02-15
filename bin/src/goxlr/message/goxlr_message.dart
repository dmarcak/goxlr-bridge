abstract class GoXLRMessage {}

class GoXLRMessageFactory {
  static GoXLRMessage createFromPayload(Map<String, dynamic> payload) {
    assert(payload.containsKey('event'));

    var event = payload['event'];

    if (event == 'goxlrConnectionEvent') {
      return GoXLRConnectionEventMessage.create(payload);
    }

    if (event == 'sendToPropertyInspector') {
      return SendToPropertyInspectorMessage.create(payload);
    }

    if (event == 'getSettings') {
      return GetSettings.create(payload);
    }

    throw Exception('Unsupported event type: $event.');
  }
}

class GoXLRConnectionEventMessage implements GoXLRMessage {
  final String device;
  final String event;

  GoXLRConnectionEventMessage(this.device, this.event);

  factory GoXLRConnectionEventMessage.create(Map<String, dynamic> payload) {
    assert(payload.containsKey('device'));
    assert(payload.containsKey('event'));

    return GoXLRConnectionEventMessage(payload['device'], payload['event']);
  }
}

class SendToPropertyInspectorMessage implements GoXLRMessage {
  final String action;
  final String context;
  final String event;
  final List<String> profiles;

  SendToPropertyInspectorMessage(
      this.action, this.context, this.event, this.profiles);

  factory SendToPropertyInspectorMessage.create(Map<String, dynamic> payload) {
    assert(payload.containsKey('action'));
    assert(payload.containsKey('context'));
    assert(payload.containsKey('event'));
    assert(payload.containsKey('payload'));
    assert(
        (payload['payload'] as Map<String, dynamic>).containsKey('Profiles'));

    var profiles = List<String>.from(payload['payload']['Profiles']);

    return SendToPropertyInspectorMessage(
        payload['action'], payload['context'], payload['event'], profiles);
  }
}

class GetSettings implements GoXLRMessage {
  final String action;
  final String context;
  final String event;

  GetSettings(this.action, this.context, this.event);

  factory GetSettings.create(Map<String, dynamic> payload) {
    assert(payload.containsKey('action'));
    assert(payload.containsKey('context'));
    assert(payload.containsKey('event'));

    return GetSettings(payload['action'], payload['context'], payload['event']);
  }
}
