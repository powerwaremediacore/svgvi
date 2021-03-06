/* main.vala
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

public class Svgvi.App : Gtk.Application {
  private Settings settings;
  private bool init;

  public string last_file { get; set; }
  public int last_row { get; set; }
  public int last_column { get; set; }
  construct {
    init = true;
    settings = null;
    SettingsSchemaSource scs = SettingsSchemaSource.get_default ();
    SettingsSchema ss = scs.lookup ("mx.pwmc.Svgvi", false);
    if (ss != null) {
      settings = new Settings ("mx.pwmc.Svgvi");
      assert (settings != null);
      last_file = settings.get_string ("last-file");
      last_row = settings.get_int ("last-row");
      last_column = settings.get_int ("last-column");
    } else {
      warning ("Application's Schema is not installed");
    }
    activate.connect (() => {
      var win = new Svgvi.Window (this);
      if (get_active_window () == null) {
        var f = File.new_for_uri (last_file);
        if (f.query_exists (null)) {
          win.file = f;
        }
      }
      win.present ();
    });
    window_removed.connect ((w)=>{
      var win = w as Svgvi.Window;
      if (settings != null) {
        if (win != null) {
          settings.set_string ("last-file", win.file.get_uri ());
          settings.set_int ("last-row", win.current_row);
          settings.set_int ("last-column", win.current_column);
        } else {
          warning ("No active window. No settings will be saved.");
        }
      } else {
        warning ("Settings were not setup. No settings will be saved.");
      }
    });
    window_added.connect ((w)=>{
      var win = w as Svgvi.Window;
      if (settings != null) {
        if (win != null && init) {
          string f = settings.get_string ("last-file");
          int r = settings.get_int ("last-row");
          int c = settings.get_int ("last-column");
          if (f == "") {
            return;
          }
          win.file = File.new_for_uri (f);
          win.current_row = r;
          win.current_column = c;
          int cw = settings.get_int ("last-window-w");
          int ch = settings.get_int ("last-window-h");
          win.resize (cw, ch);
          cw = settings.get_int ("last-window-x");
          ch = settings.get_int ("last-window-y");
          win.move (cw, ch);
          win.configure_event.connect (()=>{
            if (win == get_active_window ()) {
              int ccw, cch;
              ccw = cch = 0;
              win.get_size (out ccw, out cch);
              settings.set_int ("last-window-w", ccw);
              settings.set_int ("last-window-h", cch);
              win.get_position (out ccw, out cch);
              settings.set_int ("last-window-x", ccw);
              settings.set_int ("last-window-y", cch);
            }
          });
          init = false;
        } else {
          warning ("No active window. No settings will be set.");
        }
      } else {
        warning ("Settings were not setup. No settings will be set.");
      }
    });
  }
  public App () {
    Object (application_id: "mx.pwmc.Svgvi", flags: ApplicationFlags.FLAGS_NONE);
  }
}
