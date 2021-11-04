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

import 'dart:convert';

import 'package:resource_portable/resource.dart';

const _appFolderPath = 'web/app';
const _publicFolderPath = 'web/public';

Future<String> getIndexHtml() async {
  final resource = _getResourceForPath(_publicFolderPath + '/index.html');
  return await resource.readAsString(encoding: utf8);
}

Future<String> getStylesCss() async {
  final resource = _getResourceForPath(_publicFolderPath + '/styles.css');
  return await resource.readAsString(encoding: utf8);
}

Resource _getResourceForPath(String path) => Resource(path);
