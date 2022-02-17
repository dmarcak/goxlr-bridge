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
