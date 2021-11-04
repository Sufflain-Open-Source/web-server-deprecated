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

import 'package:mustache_template/mustache.dart';

class InfoCard {
  InfoCard(
      {required this.title, this.subtitle = '', required this.childElement});

  final String title;
  final String subtitle;
  final String childElement;

  String get outerHtml {
    final _outerHtml = '''
<div class="info-card">
    <p class="info-card-title">$title</p>
    ${() {
      return subtitle.isNotEmpty
          ? '<p class="info-card-subtitle">$subtitle</p>'
          : '';
    }()}
    $childElement
</div>''';

    return Template(_outerHtml).renderString({});
  }
}
