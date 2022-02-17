import 'package:test/test.dart';
import 'dart:convert';

import '../../bin/src/api/response.dart';

void main() {
  test('Test serialize success payload', () {
    // Given
    var payload = SuccessPayload();

    // When
    var json = jsonEncode(payload);

    // Then
    expect(json, '{"status":"ok"}');
  });

  test('Test serialize profiles payload', () {
    // Given
    var payload = ProfilesPayload(['Profile #1', 'Profile #2']);

    // When
    var json = jsonEncode(payload);

    // Then
    expect(json, '{"status":"ok","profiles":["Profile #1","Profile #2"]}');
  });

  test('Test serialize error payload', () {
    // Given
    var payload = ErrorPayload('Error message');

    // When
    var json = jsonEncode(payload);

    // Then
    expect(json, '{"status":"error","message":"Error message"}');
  });

  test('Test create FORBIDDEN json response', () async {
    // Given
    var payload = SuccessPayload();

    // When
    var response = JsonResponse.forbidden(payload);

    // Then
    expect(response.statusCode, 403);
    expect(response.headers.containsKey('Content-Type'), true);
    expect(response.headers['Content-Type'], 'application/json');
    expect(await response.readAsString(), '{"status":"ok"}');
  });

  test('Test create INTERNAL SERVER ERROR json response', () async {
    // Given
    var payload = SuccessPayload();

    // When
    var response = JsonResponse.internalServerError(payload);

    // Then
    expect(response.statusCode, 500);
    expect(response.headers.containsKey('Content-Type'), true);
    expect(response.headers['Content-Type'], 'application/json');
    expect(await response.readAsString(), '{"status":"ok"}');
  });

  test('Test create NOT FOUND json response', () async {
    // Given
    var payload = SuccessPayload();

    // When
    var response = JsonResponse.notFound(payload);

    // Then
    expect(response.statusCode, 404);
    expect(response.headers.containsKey('Content-Type'), true);
    expect(response.headers['Content-Type'], 'application/json');
    expect(await response.readAsString(), '{"status":"ok"}');
  });

  test('Test create OK json response', () async {
    // Given
    var payload = SuccessPayload();

    // When
    var response = JsonResponse.ok(payload);

    // Then
    expect(response.statusCode, 200);
    expect(response.headers.containsKey('Content-Type'), true);
    expect(response.headers['Content-Type'], 'application/json');
    expect(await response.readAsString(), '{"status":"ok"}');
  });

  test('Test create GONE json response', () async {
    // Given
    var payload = SuccessPayload();

    // When
    var response = JsonResponse.gone(payload);

    // Then
    expect(response.statusCode, 410);
    expect(response.headers.containsKey('Content-Type'), true);
    expect(response.headers['Content-Type'], 'application/json');
    expect(await response.readAsString(), '{"status":"ok"}');
  });
}
