import '../request.dart';

class FetchProfiles extends Request {
  @override
  Map<String, dynamic> toJson() {
    return {
      'action': 'com.tchelicon.goxlr.profilechange',
      'context': '',
      'event': 'propertyInspectorDidAppear'
    };
  }
}
