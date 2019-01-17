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

  public File file {
    get {
      return _file;
    }
    set {
      _file = value;
      var istream = _file.read ();
      var ostream = new MemoryOutputStream.resizable ();
      ostream.splice (istream, OutputStreamSpliceFlags.CLOSE_SOURCE, cancellable);
      source.buffer.text = (string) ostream.get_data ();
      var doc = new GSvg.GsDocument ();
      doc.read_from_string ((string) ostream.get_data ());
      viewer.svg = doc;
    }
  }

  construct {
    var box = new Gtk.Grid ();
    viewer = new Svgvi.SvgView ();
    var sw = new Gtk.ScrolledWindow (null, null);
    box.attach (sw, 0, 0, 1, 1);
    box.attach (viewer, 1, 0, 1, 1);
    viewer.expand = true;
    source = new Svgvi.SourceView ();
    sw.add (source);
    source.vexpand = true;
    sw.expand = true;
    add (box);
    expand = true;
  }
}
