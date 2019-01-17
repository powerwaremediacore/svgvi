/* editor.vala
 *
 * Copyright 2019 Daniel Espinosa Ortiz <esodan@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class Svgvi.Editor : Gtk.Grid {
  private Svgvi.SvgViewer viewer;
  private Svgvi.SourceView source;
  construct {
    viewer = new Svgvi.SvgViewer ();
    source = new Svgvi.SourceView ();
    atach (viewer, 0, 0, 1, 1);
    atach (source, 1, 0, 1, 1);
  }
}
