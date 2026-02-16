using Gee;

namespace AppstreamCreatorApp {

public class LicenseGroup : Adw.PreferencesGroup {

    public signal void changed ();

    public Adw.ComboRow metadata_license_row { get; private set; }
    public Gtk.Entry project_license_entry { get; private set; }

    public LicenseGroup () {
        this.set_title ("Лицензии");
        this.set_description ("Информация о лицензировании");

        metadata_license_row = new Adw.ComboRow ();
        metadata_license_row.set_title ("Лицензия метаданных *");
        metadata_license_row.set_subtitle ("Лицензия самого XML файла");

        var meta_license_model = new Gtk.StringList (new string[] {
            "CC0-1.0", "MIT", "FSFAP", "CC-BY-4.0"
        });
        metadata_license_row.set_model (meta_license_model);
        metadata_license_row.set_selected (0);
        metadata_license_row.notify["selected"].connect (() => changed ());
        this.add (metadata_license_row);

        var project_action_row = new Adw.ActionRow ();
        project_action_row.set_title ("Лицензия проекта *");
        project_action_row.set_subtitle ("SPDX идентификатор (GPL-3.0-only, MIT, Apache-2.0)");

        project_license_entry = new Gtk.Entry ();
        project_license_entry.hexpand = true;
        project_license_entry.changed.connect (() => changed ());

        project_action_row.add_suffix (project_license_entry);
        project_action_row.set_activatable_widget (project_license_entry);
        this.add (project_action_row);
    }

    public void update_data (AppstreamData data) {
        var meta_item = metadata_license_row.get_selected_item ();
        data.metadata_license = (meta_item as Gtk.StringObject)?.get_string () ?? "CC0-1.0";
        data.project_license = project_license_entry.get_text ();
    }

    public void load_data (AppstreamData new_data) {
        string meta_license = new_data.metadata_license;
        string proj_license = new_data.project_license;

        message ("  license_group: metadata_license='%s'", meta_license);
        message ("  license_group: project_license='%s'", proj_license);

        var meta_model = metadata_license_row.get_model () as Gtk.StringList;
        for (int i = 0; i < meta_model.get_n_items (); i++) {
            string license = meta_model.get_string (i);
            if (license == meta_license) {
                message ("  license_group: установка metadata_license на позицию %d", i);
                metadata_license_row.set_selected (i);
                break;
            } else {
                message ("  license_group: сравнение '%s' с '%s'", license, meta_license);
            }
        }

        message ("  license_group: установка project_license='%s'", proj_license);
        project_license_entry.set_text (proj_license);
    }
}

}
