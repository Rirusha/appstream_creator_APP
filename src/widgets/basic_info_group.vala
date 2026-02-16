using Gee;

namespace AppstreamCreatorApp {

public class BasicInfoGroup : Adw.PreferencesGroup {

    public signal void changed ();

    public Adw.ComboRow component_type_row { get; private set; }
    public Gtk.Entry id_entry { get; private set; }
    public Gtk.Entry name_entry { get; private set; }
    public Gtk.Entry summary_entry { get; private set; }

    public BasicInfoGroup () {
        this.set_title ("Основная информация");
        this.set_description ("Обязательные поля для AppStream");

        component_type_row = new Adw.ComboRow ();
        component_type_row.set_title ("Тип компонента");
        component_type_row.set_subtitle ("Выберите тип вашего приложения");

        var type_model = new Gtk.StringList (new string[] {
            "desktop-application", "console-application", "addon", "runtime"
        });
        component_type_row.set_model (type_model);
        component_type_row.set_selected (0);
        component_type_row.notify["selected"].connect (() => changed ());
        this.add (component_type_row);

        var id_action_row = new Adw.ActionRow ();
        id_action_row.set_title ("ID приложения *");
        id_action_row.set_subtitle ("Уникальный идентификатор (например: org.example.App)");

        id_entry = new Gtk.Entry ();
        id_entry.hexpand = true;
        id_entry.changed.connect (() => changed ());

        id_action_row.add_suffix (id_entry);
        id_action_row.set_activatable_widget (id_entry);
        this.add (id_action_row);

        var name_action_row = new Adw.ActionRow ();
        name_action_row.set_title ("Название *");
        name_action_row.set_subtitle ("Имя вашего приложения");

        name_entry = new Gtk.Entry ();
        name_entry.hexpand = true;
        name_entry.changed.connect (() => changed ());

        name_action_row.add_suffix (name_entry);
        name_action_row.set_activatable_widget (name_entry);
        this.add (name_action_row);

        var summary_action_row = new Adw.ActionRow ();
        summary_action_row.set_title ("Краткое описание *");
        summary_action_row.set_subtitle ("Одна строка о том, что делает приложение");

        summary_entry = new Gtk.Entry ();
        summary_entry.hexpand = true;
        summary_entry.changed.connect (() => changed ());

        summary_action_row.add_suffix (summary_entry);
        summary_action_row.set_activatable_widget (summary_entry);
        this.add (summary_action_row);
    }

    public void update_data (AppstreamData data) {
        var type_item = component_type_row.get_selected_item ();
        data.component_type = (type_item as Gtk.StringObject)?.get_string () ?? "desktop-application";
        data.id = id_entry.get_text ();
        data.name = name_entry.get_text ();
        data.summary = summary_entry.get_text ();
    }

    public void load_data (AppstreamData new_data) {
        string id_val = new_data.id;
        string name_val = new_data.name;
        string summary_val = new_data.summary;
        string type_val = new_data.component_type;

        message ("  basic_info_group: установка id='%s'", id_val);
        id_entry.set_text (id_val);

        message ("  basic_info_group: установка name='%s'", name_val);
        name_entry.set_text (name_val);

        message ("  basic_info_group: установка summary='%s'", summary_val);
        summary_entry.set_text (summary_val);
        var type_model = component_type_row.get_model () as Gtk.StringList;
        for (int i = 0; i < type_model.get_n_items (); i++) {
            string type = type_model.get_string (i);
            if (type == type_val) {
                message ("  basic_info_group: установка component_type='%s' на позицию %d", type_val, i);
                component_type_row.set_selected (i);
                break;
            }
        }
    }
}

}
