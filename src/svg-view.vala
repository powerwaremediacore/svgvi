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

public class Svgvi.SvgView : GSvgtk.Image {
  private GSvg.SVGElement _view;
  private string _rules_style;
  private GSvg.RectElement rectv;
  private GSvg.RectElement recth;

  public GSvg.SVGElement view { get { return _view; } }
  public string rules_style {
    get {
      return _rules_style;
    }
    set {
      _rules_style = value;
    }
  }
  construct {
    _rules_style = "fill: gray";
    svg = new GSvg.GsDocument ();
    message ("Initializing internal SVG container");
    try {
      _view = svg.add_svg (null, null, "225.9mm", "289.4mm");
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
      message ("Type x1: %s - y1: %s - x2:%s - y2:%s", utlx1.to_string (), utly1.to_string (), utlx2.to_string (), utly2.to_string ());
      bool middle = true;
      while (lx1 + 5 < recth.width.base_val.value) {
        lx1 += 5;
        lx2 += 5;
        var nlh = Object.new (typeof(GSvg.GsLineElement), "owner_document", svg) as GSvg.LineElement;
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
        view.append_child (nlh);
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
      while (ly1 + 5 < rectv.height.base_val.value) {
        ly1 += 5;
        ly2 += 5;
        var nlv = Object.new (typeof(GSvg.GsLineElement), "owner_document", svg) as GSvg.LineElement;
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
      }
      render ();
    } catch (GLib.Error e) {
      warning ("SVG Viewer Initialization Error: %s", e.message);
    }
  }
}
