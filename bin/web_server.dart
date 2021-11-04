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

import 'package:web_server/core/resources.dart' as res;

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

const _root = '/';
const _appPath = '/app';
const _anyPathAfter = '<path|.*>';

void main(List<String> arguments) {
  final router = Router();

  router.mount(_root + 'styles.css', (request) async {
    final css = await res.getStylesCss();
    return Response.ok(css, headers: {'Content-Type': 'text/css'});
  });

  router.get(_root + _anyPathAfter, (Request request) async {
    final html = await res.getIndexHtml();
    return Response.ok(html, headers: {'Content-Type': 'text/html'});
  });

  io.serve(router, 'localhost', 8080);
}
