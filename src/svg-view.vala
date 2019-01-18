/* svg-view.vala
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

public class Svgvi.SvgView : Gtk.Grid {
  private GSvgtk.Image _image;
  private GSvg.Document _svg;
  private GSvg.SVGElement _view;
  private GSvg.SVGElement _current;
  private string _rules_style;
  private GSvg.RectElement rectv;
  private GSvg.RectElement recth;

  public GSvg.Document svg {
    get { return _svg; }
    set {
      _svg = value;
      assign_svg ();
    }
  }
  public string rules_style {
    get {
      return _rules_style;
    }
    set {
      _rules_style = value;
      generate_view ();
      assign_svg ();
    }
  }
  construct {
    _image = new GSvgtk.Image ();
    attach (_image, 0, 1, 1, 1);
    _rules_style = "fill: gray";
    var f = File.new_for_uri ("resource:///mx/pwmc/Svgvi/logo-background.svg");
    generate_view ();
    try {
      var ostream = new MemoryOutputStream.resizable ();
      var istream = f.read ();
      ostream.splice (istream, OutputStreamSpliceFlags.CLOSE_SOURCE, null);
      var nsvg = new GSvg.GsDocument ();
      nsvg.read_from_string ((string) ostream.get_data ());
      svg = nsvg;
    } catch (GLib.Error e) {
      warning ("Error loading default background: %s", e.message);
    }
  }
  private void assign_svg () {
    if (_current != null) {
      _current.remove ();
      _current = null;
    }
    if (_svg != null) {
      _current = _view.add_svg ("5mm", "5mm", null, null);
      var nsvg = _current.add_svg (null, null, null, null);
      nsvg.read_from_string (_svg.write_string ());
    }
    _image.render ();
  }
  private void generate_view () {
    try {
      _image.svg = new GSvg.GsDocument ();
      _view = _image.svg.add_svg (null, null, "225.9mm", "289.4mm");
      recth = _view.create_rect ("5mm","0mm","215.9mm","5mm", null, null);
      _view.append_child (recth);
      recth.style = new GSvg.GsCSSStyleDeclaration ();
      recth.style.css_text = rules_style;
      rectv = _view.create_rect ("0mm","5mm","5mm","279.4mm", null, null);
      _view.append_child (rectv);
      rectv.style = new GSvg.GsCSSStyleDeclaration ();
      rectv.style.css_text = rules_style;
      var lstyle = new GSvg.GsCSSStyleDeclaration ();
      lstyle.css_text = """stroke: black; stroke-width: 0.25mm""";
      var lh = _view.create_line ("5mm","0mm","5mm","5mm");
      _view.append_child (lh);
      lh.style = lstyle;
      var lx1 = lh.x1.base_val.value;
      var utlx1 = lh.x1.base_val.unit_type;
      var lx2 = lh.x2.base_val.value;
      var utlx2 = lh.x2.base_val.unit_type;
      var ly1 = lh.y1.base_val.value;
      var utly1 = lh.y1.base_val.unit_type;
      var ly2 = lh.y2.base_val.value;
      var utly2 = lh.y2.base_val.unit_type;
      bool middle = true;
      int n = 0;
      while (lx1 + 5 < recth.width.base_val.value) {
        lx1 += 5;
        lx2 += 5;
        var nlh = Object.new (typeof(GSvg.GsLineElement), "owner_document", _image.svg) as GSvg.LineElement;
        nlh.style = lstyle;
        nlh.x1 = new GSvg.GsAnimatedLengthX () as GSvg.AnimatedLengthX;
        nlh.x1.base_val = new GSvg.GsLength () as GSvg.Length;
        nlh.x1.base_val.value = lx1;
        nlh.x1.base_val.unit_type = utlx1;
        nlh.x2 = new GSvg.GsAnimatedLengthX () as GSvg.AnimatedLengthX;
        nlh.x2.base_val.value = lx2;
        nlh.x2.base_val.unit_type = utlx2;
        nlh.y1 = new GSvg.GsAnimatedLengthY () as GSvg.AnimatedLengthY;
        nlh.y1.base_val.value = ly1;
        nlh.y1.base_val.unit_type = utly1;
        nlh.y2 = new GSvg.GsAnimatedLengthY () as GSvg.AnimatedLengthY;
        nlh.y2.base_val.value = ly2;
        nlh.y2.base_val.unit_type = utly2;
        if (middle) {
          nlh.y2.base_val.value /= 2;
          middle = false;
        } else {
          middle = true;
        }
        _view.append_child (nlh);
        var pos = lx1 - 5;
        if (n > 0 && (n/2.0) != (int) (n / 2.0)) {
          var txpos = new GSvg.GsLength ();
          txpos.value = nlh.x2.base_val.value + 0.2;
          txpos.unit_type = nlh.x2.base_val.unit_type;
          var typos = new GSvg.GsLength ();
          typos.value = nlh.y2.base_val.value - 0.5;
          typos.unit_type = nlh.y2.base_val.unit_type;
          var t = _view.create_text ("%d".printf ((int) pos),
                      txpos.to_string (),
                      typos.to_string (),
                      null, null,
                      """font-family: Verdana; font-size: 2.5mm; fill: black""");
          _view.append_child (t);
        }
        n++;
      }
      var lv = _view.create_line ("0mm","5mm","5mm","5mm");
      _view.append_child (lv);
      lv.style = lstyle;
      lx1 = lv.x1.base_val.value;
      utlx1 = lh.x1.base_val.unit_type;
      lx2 = lv.x2.base_val.value;
      utlx2 = lh.x2.base_val.unit_type;
      ly1 = lv.y1.base_val.value;
      utly1 = lh.y1.base_val.unit_type;
      ly2 = lv.y2.base_val.value;
      utly2 = lv.y2.base_val.unit_type;
      n = 0;
      while (ly1 + 5 < rectv.height.base_val.value) {
        ly1 += 5;
        ly2 += 5;
        var nlv = Object.new (typeof(GSvg.GsLineElement), "owner_document", _image.svg) as GSvg.LineElement;
        nlv.style = lstyle;
        nlv.x1 = new GSvg.GsAnimatedLengthX () as GSvg.AnimatedLengthX;
        nlv.x1.base_val.value = lx1;
        nlv.x1.base_val.unit_type = utlx1;
        nlv.x2 = new GSvg.GsAnimatedLengthX () as GSvg.AnimatedLengthX;
        nlv.x2.base_val.value = lx2;
        nlv.x2.base_val.unit_type = utlx2;
        nlv.y1 = new GSvg.GsAnimatedLengthY () as GSvg.AnimatedLengthY;
        nlv.y1.base_val.value = ly1;
        nlv.y1.base_val.unit_type = utly1;
        nlv.y2 = new GSvg.GsAnimatedLengthY () as GSvg.AnimatedLengthY;
        nlv.y2.base_val.value = ly2;
        nlv.y2.base_val.unit_type = utly2;
        if (middle) {
          nlv.x2.base_val.value /= 2;
          middle = false;
        } else {
          middle = true;
        }
        _view.append_child (nlv);
        var pos = ly1 - 5;
        if (n > 0 && (n/2.0) != (int) (n / 2.0)) {
          var txpos = new GSvg.GsLength ();
          txpos.value = nlv.x1.base_val.value + 0.5;
          txpos.unit_type = nlv.x1.base_val.unit_type;
          var typos = new GSvg.GsLength ();
          typos.value = nlv.y1.base_val.value - 0.5;
          typos.unit_type = nlv.y1.base_val.unit_type;
          var t = _view.create_text ("%d".printf ((int) pos),
                      txpos.to_string (),
                      typos.to_string (),
                      null, null,
                      """font-family: Verdana; font-size: 2.5mm; fill: black""");
          _view.append_child (t);
        }
        n++;
      }
    } catch (GLib.Error e) {
      warning ("SVG Viewer Initialization Error: %s", e.message);
    }
  }
}
