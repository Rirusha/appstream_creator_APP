using Gee;

namespace AppstreamCreatorApp {

public class ScreenshotGroup : Adw.PreferencesGroup {

    public signal void changed ();
    public signal void add_clicked ();

    private Gtk.ListBox list_box;
    private Gtk.ListBoxRow? default_row = null;

    public ScreenshotGroup () {
        this.set_title ("Скриншоты");
        this.set_description ("Добавьте скриншоты вашего приложения");

        var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
        button_box.set_halign (Gtk.Align.END);
        button_box.set_margin_top (10);
        button_box.set_margin_bottom (10);

        var add_button = new Gtk.Button.with_label ("Добавить скриншот");
        add_button.add_css_class ("pill");
        add_button.clicked.connect (() => add_clicked ());
        button_box.append (add_button);

        this.set_header_suffix (button_box);

        list_box = new Gtk.ListBox ();
        list_box.add_css_class ("boxed-list");
        this.add (list_box);

        show_placeholder ();
    }

    private void show_placeholder () {
        if (list_box.get_row_at_index (0) == null) {
            var placeholder = new Adw.ActionRow ();
            placeholder.set_title ("Нет скриншотов");
            placeholder.set_subtitle ("Нажмите 'Добавить скриншот' чтобы добавить");
            list_box.append (placeholder);
        }
    }

    public void add_screenshot (Screenshot shot) {
        var first_row = list_box.get_row_at_index (0);
        if (first_row != null && first_row is Adw.ActionRow) {
            var action_row = first_row as Adw.ActionRow;
            if (action_row.get_title () == "Нет скриншотов") {
                list_box.remove (first_row);
            }
        }

        var row = new Adw.ActionRow ();
        row.set_title (shot.url);
        if (shot.caption != "")
            row.set_subtitle (shot.caption);

        if (shot.is_default) {
            var default_label = new Gtk.Label ("default");
            default_label.add_css_class ("caption");
            default_label.add_css_class ("success");
            row.add_suffix (default_label);
            default_row = row;
        }

        var delete_btn = new Gtk.Button.from_icon_name ("user-trash-symbolic");
        delete_btn.add_css_class ("flat");
        delete_btn.add_css_class ("destructive-action");
        delete_btn.clicked.connect (() => {
            list_box.remove (row);
            if (row == default_row) default_row = null;
            show_placeholder ();
            changed ();
        });
        row.add_suffix (delete_btn);

        list_box.append (row);
        changed ();
    }

    public Gee.ArrayList<Screenshot> get_screenshots () {
        var shots = new Gee.ArrayList<Screenshot> ();
        var row = list_box.get_row_at_index (0);
        while (row != null) {
            if (row is Adw.ActionRow) {
                var action_row = row as Adw.ActionRow;
                if (action_row.get_title () != "Нет скриншотов") {
                    var shot = new Screenshot (
                        action_row.get_title (),
                        action_row.get_subtitle () ?? ""
                    );
                    shots.add (shot);
                }
            }
            row = row.get_next_sibling () as Gtk.ListBoxRow;
        }
        return shots;
    }
}

}
