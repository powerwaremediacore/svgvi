/* source-view.vala
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
using Gtk;

public class Svgvi.SourceView : Gtk.SourceView {
  construct {
    editable = true;
    cursor_visible = true;
    monospace = true;
    auto_indent = true;
    highlight_current_line = true;
    indent_on_tab = true;
    indent_width = 4;
    show_line_marks = true;
    show_line_numbers = true;
    smart_backspace = true;
    var b = get_buffer () as Gtk.SourceBuffer;
    b.highlight_matching_brackets = true;
    b.highlight_syntax = true;
    var lman = SourceLanguageManager.get_default ();
    ((Gtk.SourceBuffer) buffer).language = lman.get_language ("xml");
  }
}
