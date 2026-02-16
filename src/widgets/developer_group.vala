using Gee;

namespace AppstreamCreatorApp {

public class DeveloperGroup : Adw.PreferencesGroup {

    public signal void changed ();

    public Gtk.Entry developer_id_entry { get; private set; }
    public Gtk.Entry developer_name_entry { get; private set; }

    public DeveloperGroup () {
        this.set_title ("Разработчик");
        this.set_description ("Информация о создателе приложения");

        var id_action_row = new Adw.ActionRow ();
        id_action_row.set_title ("ID разработчика *");
        id_action_row.set_subtitle ("Reverse-DNS (например: org.example)");

        developer_id_entry = new Gtk.Entry ();
        developer_id_entry.hexpand = true;
        developer_id_entry.changed.connect (() => changed ());

        id_action_row.add_suffix (developer_id_entry);
        id_action_row.set_activatable_widget (developer_id_entry);
        this.add (id_action_row);

        var name_action_row = new Adw.ActionRow ();
        name_action_row.set_title ("Имя разработчика *");
        name_action_row.set_subtitle ("Название команды или имя автора");

        developer_name_entry = new Gtk.Entry ();
        developer_name_entry.hexpand = true;
        developer_name_entry.changed.connect (() => changed ());

        name_action_row.add_suffix (developer_name_entry);
        name_action_row.set_activatable_widget (developer_name_entry);
        this.add (name_action_row);
    }

    public void update_data (AppstreamData data) {
        data.developer_id = developer_id_entry.get_text ();
        data.developer_name = developer_name_entry.get_text ();
    }

    public void load_data (AppstreamData new_data) {
        string dev_id = new_data.developer_id;
        string dev_name = new_data.developer_name;

        message ("  dev_group: developer_id='%s'", dev_id);
        message ("  dev_group: developer_name='%s'", dev_name);

        developer_id_entry.set_text (dev_id);
        developer_name_entry.set_text (dev_name);
    }
}

}
