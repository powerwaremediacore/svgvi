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

public class Svgvi.Editor : Gtk.ScrolledWindow {
  private Svgvi.SvgView viewer;
  private Svgvi.SourceView source;
  private File _file = null;
  private Cancellable cancellable = null;

  public signal void updated ();

  public File file {
    get {
      return _file;
    }
    set {
      _file = value;
      try {
        var istream = _file.read ();
        var ostream = new MemoryOutputStream.resizable ();
        ostream.splice (istream, OutputStreamSpliceFlags.CLOSE_SOURCE, cancellable);
        source.buffer.text = (string) ostream.get_data ();
        var doc = new GSvg.GsDocument ();
        doc.read_from_string ((string) ostream.get_data ());
        viewer.svg = doc;
      } catch (GLib.Error e) {
        warning ("Error parsing SVG source File: %s", e.message);
      }
    }
  }

  public int current_row { get; set; }
  public int current_column { get; set; }

  construct {
    var box = new Gtk.Paned (Gtk.Orientation.VERTICAL);
    var sw1 = new Gtk.ScrolledWindow (null, null);
    var sw2 = new Gtk.ScrolledWindow (null, null);
    box.pack1 (sw1, true, true);
    box.pack2 (sw2, true, true);
    source = new Svgvi.SourceView ();
    sw1.add (source);
    source.vexpand = true;
    viewer = new Svgvi.SvgView ();
    sw2.add (viewer);
    viewer.expand = true;
    add (box);
    expand = true;

    source.buffer.end_user_action.connect (()=>{
      try {
        var doc = new GSvg.GsDocument ();
        doc.read_from_string (source.buffer.text);
        viewer.svg = doc;
        doc.write_file (file);
        updated ();
      } catch {}
    });
    source.buffer.insert_text.connect ((ref pos, new_text, new_text_length)=>{
      current_row = pos.get_line ();
      current_column = pos.get_line_offset ();
    });
  }
  public void save_to (File f) {
    try {
      (viewer.svg as GXml.GomDocument).write_file (f);
      file = f;
    } catch (GLib.Error e) {
      warning ("Error while trying to saving as, SVG file: %s", e.message);
    }
  }
}
