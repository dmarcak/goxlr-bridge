import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';

class Profile {
  final String name;

  Profile(this.name);

  static FutureOr<Profile> createFromRequest(Request request) async {
    var payload = jsonDecode(await request.readAsString());

    return Profile(payload['name']);
  }
}
