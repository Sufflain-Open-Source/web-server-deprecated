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

import 'package:shelf_virtual_directory/shelf_virtual_directory.dart';
import 'package:web_server/core/resources.dart' as res;

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:web_server/ui/components/image.dart';
import 'package:web_server/ui/components/info_card.dart';
import 'package:web_server/ui/landing_page_modifier.dart';

const _root = '/';
const _appPath = '/app/';
const _anyPathAfter = '<path|.*>';

void main(List<String> arguments) async {
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

  router.mount(_appPath, ShelfVirtualDirectory('web/app/build').handler);

  router.get(
      _root + _anyPathAfter,
      (Request request) => Response.ok(landingPageModifier.outerHtml,
          headers: {'Content-Type': 'text/html'}));

  io.serve(router, 'localhost', 8080);
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
          childElement:
              createButton('Написать нам', 'mailto:crt0r.9@yahoo.com'))
      .outerHtml);

  landingPageModifier.appendChild(InfoCard(
          title: 'Мы за Open Source.',
          childElement: createButton(
              'Посмотреть исходный код', 'https://gitlab.com/Sufflain'))
      .outerHtml);
}

String createButton(String title, String link) => '''
  <a class="button" href="$link">$title</a>
  ''';

String createImageElement(String fileName) =>
    Image(res.imagesPath + '/$fileName').outerHtml;
