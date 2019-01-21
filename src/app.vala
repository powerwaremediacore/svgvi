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

  public string last_file { get; set; }
  public int last_row { get; set; }
  public int last_column { get; set; }
  construct {
    settings = null;
    SettingsSchemaSource scs = SettingsSchemaSource.get_default ();
    SettingsSchema ss = scs.lookup ("/mx/pwmc/Svgvi", false);
    if (ss != null) {
      settings = new Settings ("/mx/pwmc/Svgvi");
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
    shutdown.connect (()=>{
      var win = get_active_window () as Svgvi.Window;
      if (win != null && settings != null) {
        settings.set_string ("last-file", win.file.get_uri ());
        settings.set_int ("last-row", win.current_row);
        settings.set_int ("last-column", win.current_column);
      } else {
        warning ("Settings were not setup. No settings will be saved.");
      }
    });
  }
  public App () {
    Object (application_id: "mx.pwmc.Svgvi", flags: ApplicationFlags.FLAGS_NONE);
  }
}
