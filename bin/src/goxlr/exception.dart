class GoXLRUnavailable implements Exception {
  @override
  String toString() => 'GoXLR is unavailable.';
}

class ProfileNotFound implements Exception {
  final String name;

  ProfileNotFound(this.name);

  @override
  String toString() => 'Profile $name not found.';
}

class InvalidMessage implements Exception {
  final String message;

  InvalidMessage(this.message);

  @override
  String toString() => message;
}

class UnsupportedEvent implements Exception {
  final String name;

  UnsupportedEvent(this.name);

  @override
  String toString() => 'Event $name is not supported.';
}
