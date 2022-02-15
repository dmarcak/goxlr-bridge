import 'package:test/test.dart';
import 'dart:convert';

import '../../../bin/src/goxlr/message/goxlr_message.dart';

void main() {
  test('Create profile list from json', () {
    String json =
        '{"action":"com.tchelicon.goxlr.profilechange", "context": "", "event":"sendToPropertyInspector","payload":{"Profiles":["My Profile","Sleep"]}}';

    var message = GoXLRMessageFactory.createFromPayload(jsonDecode(json))
        as SendToPropertyInspectorMessage;

    expect(message.action, 'com.tchelicon.goxlr.profilechange');
    expect(message.context, '');
    expect(message.event, 'sendToPropertyInspector');
    expect(message.profiles.length, 2);
    expect(message.profiles[0], 'My Profile');
    expect(message.profiles[1], 'Sleep');
  });
}
