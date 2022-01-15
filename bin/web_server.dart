/*
    Copyright (C) 2021  Timofey Chuchkanov

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:web_server/ui/components/button.dart';
import 'package:shelf_virtual_directory/shelf_virtual_directory.dart';
import 'package:web_server/core/resources.dart' as res;

import 'dart:io' as dart_io;
import 'package:args/args.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:web_server/ui/components/image.dart';
import 'package:web_server/ui/components/info_card.dart';
import 'package:web_server/ui/landing_page_modifier.dart';

const _defaultIpAddress = '127.0.0.1';
const _defaultTcpPort = 80;

const _contactEmail = 'crt0r.9@yahoo.com';
const _sourceCodeLink = 'https://gitlab.com/Sufflain';

const _root = '/';
const _appPath = '/app';

const _addressKey = 'address';
const _portKey = 'port';

bool _isHelpFlagEnabled = false;
bool _isMaintenanceFlagEnabled = false;

void main(List<String> arguments) async {
  final shelf.Handler handler;

  final parsedArgs = _parseArgumentsAndBindToActions(arguments);
  final address = parsedArgs[_addressKey];
  final port = parsedArgs[_portKey];
  final router = Router();
  final landingPageInitial = await res.getIndexHtml();
  final landingPageModifier = LandingPageModifier(landingPageInitial);

  final appendAppPathTrailingSlashIfNeeded =
      shelf.createMiddleware(requestHandler: (shelf.Request request) {
    final initialPath = request.requestedUri.path;
    final newPath = '$_appPath/';

    if (initialPath == _appPath) {
      return shelf.Response.movedPermanently(newPath);
    }
  });

  if (!_isMaintenanceFlagEnabled) {
    _bootstrapPage(landingPageModifier);
    landingPageModifier.writeToPublicFile();

    router.mount(_root + res.imagesPath,
        ShelfVirtualDirectory(res.imagesPath, listDirectory: false).handler);

    router.mount(_appPath,
        ShelfVirtualDirectory(res.appFolderPath, listDirectory: false).handler);

    router.mount(
        _root,
        ShelfVirtualDirectory(res.publicFolderPath, listDirectory: false)
            .handler);
  } else {
    router.mount(
        '/',
        (_) => shelf.Response.ok(
            '<h1>Сайт временно недоступен. Проводятся технические работы.</h1>',
            headers: {'Content-Type': 'text/html'}));
  }

  handler = shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(appendAppPathTrailingSlashIfNeeded)
      .addHandler(router);

  try {
    final server = await io.serve(handler, address, port);

    print('Serving on ${server.address}:${server.port}');
  } catch (e) {
    print(() {
      final socketException = (e as dart_io.SocketException);

      return (socketException.osError?.message ?? socketException.message) +
          '\n\nAddress: ${socketException.address}:${socketException.port}';
    }());
  }
}

Map<String, dynamic> _parseArgumentsAndBindToActions(List<String> arguments) {
  final parsedValues = <String, dynamic>{};
  final parser = ArgParser();

  parser.addFlag('maintenance', abbr: 'm', help: 'Serve the maintenance page.',
      callback: (bool isFlagEnabled) {
    _isMaintenanceFlagEnabled = isFlagEnabled;
  });

  parser.addFlag('help', abbr: 'h', help: 'Show help.',
      callback: (bool isFlagEnabled) {
    _isHelpFlagEnabled = isFlagEnabled;

    if (_isHelpFlagEnabled) {
      final helpMessage = _generateHelpMessage(parser.usage);

      print(helpMessage);

      dart_io.exit(0);
    }
  }, negatable: false);

  parser.addOption('address', abbr: 'a', help: 'Set the web server IP address.',
      callback: (addr) {
    parsedValues[_addressKey] =
        addr ?? _notifyUseDefault('IP address', _defaultIpAddress);
  });

  parser.addOption('port', abbr: 'p', help: 'Set the web server TCP port.',
      callback: (port) {
    parsedValues[_portKey] = int.tryParse(port ?? '') ??
        _notifyUseDefault('TCP port', _defaultTcpPort);
  });

  parser.parse(arguments);

  return parsedValues;
}

// When the parsed argument value is null, notify the user and return the default value.
// [defaultEntityName] is a thing for which we are setting the default value.
dynamic _notifyUseDefault(String defaultEntityName, dynamic defaultValue) {
  if (!_isHelpFlagEnabled) {
    print('Using the default $defaultEntityName :: $defaultValue');
  }

  return defaultValue;
}

String _generateHelpMessage(String parserUsage) => '''
A Sufflain's web server application.

Usage: sflw <option> [arguments]

Options:
$parserUsage

NOTE: The default IP address is $_defaultIpAddress, and the default TCP port number is $_defaultTcpPort.
''';

void _bootstrapPage(LandingPageModifier landingPageModifier) {
  landingPageModifier.appendChild(InfoCard(
          title: 'Больше не нужно искать.',
          subtitle:
              'Расписание разделено по группам.<br>Никакой лишней информации.',
          childElement: _createImageElement(
              'timetable-25-oct-mobile-edited.png',
              'Sufflain screenshot: timetable'))
      .outerHtml);

  landingPageModifier.appendChild(InfoCard(
          title: 'Всегда под рукой.',
          subtitle: 'Разработано с рассчётом на мобильные устройства.',
          childElement: _createImageElement(
              'main-mobile.png', 'Sufflain screenshot: main page'))
      .outerHtml);

  landingPageModifier.appendChild(InfoCard(
          title: 'Зачем?',
          subtitle:
              'Мы устали от:<br>- огромных таблиц с перемешанными расписаниями<br>- неадаптивного интерфейса',
          childElement: _createImageElement(
              'college-timetable.png', 'College site screenshot'))
      .outerHtml);

  landingPageModifier.appendChild(InfoCard(
          title: 'Есть вопросы/предложения?',
          childElement: makeButton('Написать нам', 'mailto:$_contactEmail'))
      .outerHtml);

  landingPageModifier.appendChild(InfoCard(
          title: 'Мы за Open Source.',
          childElement: makeButton('Посмотреть исходный код', _sourceCodeLink))
      .outerHtml);
}

String _createImageElement(String fileName, String alt) =>
    Image(res.imagesPath + '/$fileName', alt).outerHtml;
