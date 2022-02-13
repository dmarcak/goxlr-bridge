class FetchProfiles {
  String action = 'com.tchelicon.goxlr.profilechange';
  String context = '';
  String event = 'propertyInspectorDidAppear';

  FetchProfiles();

  Map toJson() => {'action': action, 'context': context, 'event': event};
}
