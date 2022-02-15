import 'dart:convert';
import 'package:shelf/shelf.dart' as shelf;

enum ResponseStatus { ok, error }

class SuccessPayload {
  final ResponseStatus _status;

  SuccessPayload({ResponseStatus status = ResponseStatus.ok})
      : _status = status;

  Map<String, dynamic> toJson() => {'status': _status.name};
}

class ProfilesPayload extends SuccessPayload {
  final List<String> _profiles;

  ProfilesPayload(this._profiles) : super();

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'profiles': _profiles};
}

class ErrorPayload extends SuccessPayload {
  final String _message;

  ErrorPayload(dynamic exception)
      : _message = exception.toString(),
        super(status: ResponseStatus.error);

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'message': _message};
}

class JsonResponse extends shelf.Response {
  static final Map<String, String> _headers = {
    'Content-type': 'application/json'
  };

  JsonResponse.forbidden(body)
      : super.forbidden(jsonEncode(body), headers: _headers);
  JsonResponse.internalServerError(body)
      : super.internalServerError(body: json.encode(body), headers: _headers);
  JsonResponse.notFound(body)
      : super.notFound(jsonEncode(body), headers: _headers);
  JsonResponse.ok(body) : super.ok(jsonEncode(body), headers: _headers);
  JsonResponse.gone(body)
      : super(410, body: jsonEncode(body), headers: _headers);
}
