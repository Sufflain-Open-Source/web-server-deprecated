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

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:web_server/ui/components/image.dart';
import 'package:web_server/ui/components/info_card.dart';
import 'package:web_server/ui/landing_page_modifier.dart';

const _root = '/';
const _appPath = '/app';

void main(List<String> arguments) async {
  final port = getPortFromArgument(arguments);
  final router = Router();
  final landingPageInitial = await res.getIndexHtml();
  final landingPageModifier = LandingPageModifier(landingPageInitial);

  bootstrapPage(landingPageModifier);

  router.mount(_root + 'styles.css', (request) async {
    final css = await res.getStylesCss();
    return Response.ok(css, headers: {'Content-Type': 'text/css'});
  });

  router.mount(
      _root + res.imagesPath, ShelfVirtualDirectory(res.imagesPath).handler);

  router.mount(_appPath, ShelfVirtualDirectory(res.appFolderPath).handler);

  router.get(
      _root,
      (Request request) => Response.ok(landingPageModifier.outerHtml,
          headers: {'Content-Type': 'text/html'}));

  io.serve(router, 'localhost', port);
}

void bootstrapPage(LandingPageModifier landingPageModifier) {
  landingPageModifier.appendChild(InfoCard(
          title: 'Больше не нужно искать.',
          subtitle:
              'Расписание разделено по группам.<br>Никакой лишней информации.',
          childElement:
              createImageElement('timetable-25-oct-mobile-edited.png'))
      .outerHtml);

  landingPageModifier.appendChild(InfoCard(
          title: 'Всегда под рукой.',
          subtitle: 'Разработано с рассчётом на мобильные устройства.',
          childElement: createImageElement('main-mobile.png'))
      .outerHtml);

  landingPageModifier.appendChild(InfoCard(
          title: 'Зачем?',
          subtitle:
              'Мы устали от:<br>- огромных таблиц с перемешанными расписаниями<br>- неадаптивного интерфейса',
          childElement: createImageElement('college-timetable.png'))
      .outerHtml);

  landingPageModifier.appendChild(InfoCard(
          title: 'Есть вопросы/предложения?',
          childElement: makeButton('Написать нам', 'mailto:crt0r.9@yahoo.com'))
      .outerHtml);

  landingPageModifier.appendChild(InfoCard(
          title: 'Мы за Open Source.',
          childElement: makeButton(
              'Посмотреть исходный код', 'https://gitlab.com/Sufflain'))
      .outerHtml);
}

int getPortFromArgument(List<String> args) {
  int result = 80;
  args.isNotEmpty ? result = int.tryParse(args[0]) as int : result;

  return result;
}

String createImageElement(String fileName) =>
    Image(res.imagesPath + '/$fileName').outerHtml;
