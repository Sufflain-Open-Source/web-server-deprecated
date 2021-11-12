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

import '../core/resources.dart' as res;

import 'package:html/parser.dart';
import 'dart:io';

class LandingPageModifier {
  LandingPageModifier(this._initialHtml);

  String _initialHtml;
  File outputFile = File('${res.publicFolderPath}/index.html');

  void appendChild(String html) {
    final document = parse(_initialHtml);
    final infoCardsSection = document.getElementById('info-cards');
    final innerHtml = infoCardsSection?.innerHtml ?? '';
    infoCardsSection?.innerHtml = innerHtml + html;

    _initialHtml = document.outerHtml;
  }

  String get outerHtml => _initialHtml;

  void writeToPublicFile() => outputFile.writeAsStringSync(_initialHtml);
}
