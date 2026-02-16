using Gee;

namespace AppstreamCreatorApp {

public class LaunchGroup : Adw.PreferencesGroup {

    public signal void changed ();

    public Gtk.Entry launchable_entry { get; private set; }

    public LaunchGroup () {
        this.set_title ("Запуск");
        this.set_description ("Информация о запуске приложения");

        var launch_action_row = new Adw.ActionRow ();
        launch_action_row.set_title ("Desktop файл");
        launch_action_row.set_subtitle ("Имя .desktop файла (org.example.App.desktop)");

        launchable_entry = new Gtk.Entry ();
        launchable_entry.hexpand = true;
        launchable_entry.changed.connect (() => changed ());

        launch_action_row.add_suffix (launchable_entry);
        launch_action_row.set_activatable_widget (launchable_entry);
        this.add (launch_action_row);
    }

    public void update_data (AppstreamData data) {
        data.launchable = launchable_entry.get_text ();
    }

    public void load_data (AppstreamData new_data) {
        string launch_val = new_data.launchable;

        message ("  launch_group: launchable='%s'", launch_val);
        launchable_entry.set_text (launch_val);
    }
}

}
