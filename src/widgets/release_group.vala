using Gee;

namespace AppstreamCreatorApp {

public class ReleaseGroup : Adw.PreferencesGroup {

    public signal void changed ();
    public signal void add_clicked ();

    private Gtk.ListBox list_box;

    public ReleaseGroup () {
        this.set_title ("Релизы");
        this.set_description ("Информация о версиях приложения");

        var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
        button_box.set_halign (Gtk.Align.END);
        button_box.set_margin_top (10);
        button_box.set_margin_bottom (10);

        var add_button = new Gtk.Button.with_label ("Добавить релиз");
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
            placeholder.set_title ("Нет релизов");
            placeholder.set_subtitle ("Нажмите 'Добавить релиз' чтобы добавить");
            list_box.append (placeholder);
        }
    }

    public void add_release (Release rel) {
        var first_row = list_box.get_row_at_index (0);
        if (first_row != null && first_row is Adw.ActionRow) {
            var action_row = first_row as Adw.ActionRow;
            if (action_row.get_title () == "Нет релизов") {
                list_box.remove (first_row);
            }
        }

        var row = new Adw.ActionRow ();
        row.set_title ("Версия: " + rel.version);
        row.set_subtitle ("Дата: " + rel.date);

        if (rel.description.strip () != "") {
            var desc_label = new Gtk.Label (rel.description);
            desc_label.set_wrap (true);
            desc_label.set_max_width_chars (40);
            desc_label.add_css_class ("caption");
            row.add_suffix (desc_label);
        }

        var delete_btn = new Gtk.Button.from_icon_name ("user-trash-symbolic");
        delete_btn.add_css_class ("flat");
        delete_btn.add_css_class ("destructive-action");
        delete_btn.clicked.connect (() => {
            list_box.remove (row);
            show_placeholder ();
            changed ();
        });
        row.add_suffix (delete_btn);

        list_box.append (row);
        changed ();
    }

    public Gee.ArrayList<Release> get_releases () {
        var releases = new Gee.ArrayList<Release> ();
        var row = list_box.get_row_at_index (0);
        while (row != null) {
            if (row is Adw.ActionRow) {
                var action_row = row as Adw.ActionRow;
                if (action_row.get_title () != "Нет релизов") {
                    string title = action_row.get_title ();
                    string subtitle = action_row.get_subtitle () ?? "";

                    string version = title.replace ("Версия: ", "");
                    string date = subtitle.replace ("Дата: ", "");

                    var rel = new Release (version, date, "");
                    releases.add (rel);
                }
            }
            row = row.get_next_sibling () as Gtk.ListBoxRow;
        }
        return releases;
    }
}

}
