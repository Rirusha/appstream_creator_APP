using Gee;

namespace AppstreamCreatorApp {

public class BrandingGroup : Adw.PreferencesGroup {

    public signal void changed ();

    public Gtk.ColorDialogButton light_button { get; private set; }
    public Gtk.ColorDialogButton dark_button { get; private set; }

    public BrandingGroup () {
        this.set_title ("Брендинг");
        this.set_description ("Цвета для оформления");

        var color_dialog = new Gtk.ColorDialog ();

        var light_row = new Adw.ActionRow ();
        light_row.set_title ("Цвет (светлая тема)");
        light_row.set_subtitle ("Выберите основной цвет");

        light_button = new Gtk.ColorDialogButton (color_dialog);
        Gdk.RGBA light_color = { 0.55f, 0.37f, 0.98f, 1.0f };
        light_button.set_rgba (light_color);
        light_button.notify["rgba"].connect (() => changed ());

        light_row.add_suffix (light_button);
        light_row.set_activatable_widget (light_button);
        this.add (light_row);

        var dark_row = new Adw.ActionRow ();
        dark_row.set_title ("Цвет (темная тема)");
        dark_row.set_subtitle ("Выберите основной цвет");

        dark_button = new Gtk.ColorDialogButton (color_dialog);
        Gdk.RGBA dark_color = { 0.36f, 0.13f, 0.85f, 1.0f };
        dark_button.set_rgba (dark_color);
        dark_button.notify["rgba"].connect (() => changed ());

        dark_row.add_suffix (dark_button);
        dark_row.set_activatable_widget (dark_button);
        this.add (dark_row);
    }

    public void update_data (AppstreamData data) {
        data.light_color = light_button.get_rgba ();
        data.dark_color = dark_button.get_rgba ();
    }

    public void load_data (AppstreamData data) {
        message ("  branding_group: light_color=%s", data.light_color.to_string ());
        message ("  branding_group: dark_color=%s", data.dark_color.to_string ());

        light_button.set_rgba (data.light_color);
        dark_button.set_rgba (data.dark_color);
    }
}

}
