import 'package:test/test.dart';
import 'dart:convert';

import '../../../bin/src/goxlr/exception.dart';
import '../../../bin/src/goxlr/message/goxlr_message.dart';

void main() {
  test('Test create goxlrConnectionEvent from json', () {
    // Given
    var json = '{"device": "GoXLR", "event": "goxlrConnectionEvent"}';

    // When
    var message = GoXLRMessageFactory.createFromPayload(jsonDecode(json));

    // Then
    expect(message, (value) => value is GoXLRConnectionEventMessage);

    if (message is GoXLRConnectionEventMessage) {
      expect(message.device, 'GoXLR');
      expect(message.event, 'goxlrConnectionEvent');
    }
  });

  test('Test create sendToPropertyInspector event from json', () {
    // Given
    String json =
        '{"action":"com.tchelicon.goxlr.profilechange", "context": "", "event":"sendToPropertyInspector","payload":{"Profiles":["My Profile","Sleep"]}}';

    // When
    var message = GoXLRMessageFactory.createFromPayload(jsonDecode(json));

    // Then
    expect(message, (value) => value is SendToPropertyInspectorMessage);

    if (message is SendToPropertyInspectorMessage) {
      expect(message.action, 'com.tchelicon.goxlr.profilechange');
      expect(message.context, '');
      expect(message.event, 'sendToPropertyInspector');
      expect(message.profiles.length, 2);
      expect(message.profiles[0], 'My Profile');
      expect(message.profiles[1], 'Sleep');
    }
  });

  test('Test create getSettings from json', () {
    // Given
    String json =
        '{"action":"com.tchelicon.goxlr.profilechange", "context": "", "event":"getSettings"}';

    // When
    var message = GoXLRMessageFactory.createFromPayload(jsonDecode(json));

    // Then
    expect(message, (value) => value is GetSettings);

    if (message is GetSettings) {
      expect(message.action, 'com.tchelicon.goxlr.profilechange');
      expect(message.context, '');
      expect(message.event, 'getSettings');
    }
  });

  test('Test throw exception when unsupported event occurs', () {
    // Given
    String json = '{"event": "non-existing-event"}';

    // Expects
    expect(() => GoXLRMessageFactory.createFromPayload(jsonDecode(json)),
        throwsA(TypeMatcher<UnsupportedEvent>()));
  });

  test('Test throw exception when no event is passed', () {
    // Given
    String json = '{"another":"field"}';

    // Expects
    expect(() => GoXLRMessageFactory.createFromPayload(jsonDecode(json)),
        throwsA(TypeMatcher<InvalidMessage>()));
  });
  test('Test throw exception when invalid event is passed', () {
    // Given
    String json = '{"event":{}}';

    // Expects
    expect(() => GoXLRMessageFactory.createFromPayload(jsonDecode(json)),
        throwsA(TypeMatcher<InvalidMessage>()));
  });
}
