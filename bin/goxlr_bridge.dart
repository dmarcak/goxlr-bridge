import "package:dart_amqp/dart_amqp.dart";
import 'dart:convert';

import 'api/api.dart';
import 'goxlr/goxlr.dart';

void main() {
  var goXLR = GoXLR();
  var api = Api(goXLR, port: 1258);
}
