import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';

import 'src/api/response.dart';
import 'src/goxlr/exception.dart';
import 'src/goxlr/model/profile.dart';
import 'src/goxlr/model/routing_table.dart';
import 'src/manager.dart';
import 'src/server.dart' as server;

Future<Response> setRoutingTable(GoXLRManager manager, Request req) async {
  try {
    manager.goXLR.setRoutingTable(await RoutingTable.createFromRequest(req));
    return JsonResponse.ok(SuccessPayload());
  } on GoXLRUnavailable catch (exception) {
    return JsonResponse.gone(ErrorPayload(exception));
  } on ProfileNotFound catch (exception) {
    return JsonResponse.notFound(ErrorPayload(exception));
  } catch (exception) {
    return JsonResponse.internalServerError(ErrorPayload(exception));
  }
}

Future<Response> setProfile(GoXLRManager manager, Request req) async {
  try {
    manager.goXLR.setProfile(await Profile.createFromRequest(req));
    return JsonResponse.ok(SuccessPayload());
  } on GoXLRUnavailable catch (exception) {
    return JsonResponse.gone(ErrorPayload(exception));
  } catch (exception) {
    return JsonResponse.internalServerError(ErrorPayload(exception));
  }
}

Future<Response> fetchProfiles(GoXLRManager manager) async {
  try {
    manager.goXLR.fetchProfiles();
    return JsonResponse.ok(SuccessPayload());
  } on GoXLRUnavailable catch (exception) {
    return JsonResponse.gone(ErrorPayload(exception));
  } catch (exception) {
    return JsonResponse.internalServerError(ErrorPayload(exception));
  }
}

Future<Response> listProfiles(GoXLRManager manager) async {
  try {
    return JsonResponse.ok(ProfilesPayload(manager.goXLR.profiles));
  } on GoXLRUnavailable catch (exception) {
    return JsonResponse.gone(ErrorPayload(exception));
  } catch (exception) {
    return JsonResponse.internalServerError(ErrorPayload(exception));
  }
}

ArgResults handleCommandLineArguments(ArgParser parser, List<String> args) {
  parser.addOption('host',
      abbr: 'h',
      help: 'Address of network interface which app listens on.',
      defaultsTo: InternetAddress.loopbackIPv4.address,
      valueHelp: '0.0.0.0');

  parser.addFlag('help', help: 'Print this informations.');
  parser.addFlag('debug', help: 'Enables debug mode.');

  return parser.parse(args);
}

void handleLogEntry(LogRecord record) {
  print('[${record.time}] [${record.level.name}]: ${record.message}');

  if (record.error != null) {
    print(record.error);
  }
}

void main(List<String> arguments) async {
  var parser = ArgParser();
  var args = handleCommandLineArguments(parser, arguments);

  if (args['help']) {
    print(parser.usage);
    exit(0);
  }

  Logger.root.level = args['debug'] ? Level.ALL : Level.INFO;
  Logger.root.onRecord.listen(handleLogEntry);

  var logger = Logger('GoXLR Bridge');
  var manager = GoXLRManager();

  server.Server(logger, manager, host: args['host'])
      .add('POST', '/api/routing-table',
          (Request request) => setRoutingTable(manager, request))
      .add('POST', '/api/profile',
          (Request request) => setProfile(manager, request))
      .add('POST', '/api/profile/fetch',
          (Request request) => fetchProfiles(manager))
      .add('GET', '/api/profile', (Request request) => listProfiles(manager))
      .listen(
          (server) =>
              logger.info('Listening on ${server.address.host}:${server.port}'),
          onError: (e, stackTrace) =>
              logger.shout('Unable to start app.', e, stackTrace));
}
