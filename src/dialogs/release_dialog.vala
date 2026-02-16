namespace AppstreamCreatorApp {

public class ReleaseDialog : Adw.Window {

    public signal void release_added (Release rel);

    private Gtk.Entry version_entry;
    private Gtk.Entry date_entry;
    private Gtk.TextView description_view;
    private Gtk.Button add_button;

    public ReleaseDialog (Gtk.Window parent) {
        this.set_transient_for (parent);
        this.set_modal (true);
        this.set_title ("Добавить релиз");
        this.set_default_size (450, 400);

        var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 20);
        content.set_margin_top (20);
        content.set_margin_bottom (20);
        content.set_margin_start (20);
        content.set_margin_end (20);

        var title = new Gtk.Label ("");
        title.set_markup ("<big><b>Новый релиз</b></big>");
        title.set_halign (Gtk.Align.CENTER);
        content.append (title);


        var version_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        var version_label = new Gtk.Label ("Версия *");
        version_label.set_halign (Gtk.Align.START);
        version_label.add_css_class ("heading");
        version_box.append (version_label);

        version_entry = new Gtk.Entry ();
        version_entry.set_placeholder_text ("1.0.0");
        version_entry.set_hexpand (true);
        version_entry.changed.connect (check_valid);
        version_box.append (version_entry);
        content.append (version_box);

        var date_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        var date_label = new Gtk.Label ("Дата * (ГГГГ-ММ-ДД)");
        date_label.set_halign (Gtk.Align.START);
        date_label.add_css_class ("heading");
        date_box.append (date_label);

        date_entry = new Gtk.Entry ();
        date_entry.set_placeholder_text ("2024-01-18");
        date_entry.set_hexpand (true);
        date_entry.changed.connect (check_valid);
        date_box.append (date_entry);
        content.append (date_box);

        var desc_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        var desc_label = new Gtk.Label ("Описание изменений");
        desc_label.set_halign (Gtk.Align.START);
        desc_label.add_css_class ("heading");
        desc_box.append (desc_label);

        var scrolled = new Gtk.ScrolledWindow ();
        scrolled.set_vexpand (true);
        scrolled.set_size_request (-1, 150);

        description_view = new Gtk.TextView ();
        description_view.set_wrap_mode (Gtk.WrapMode.WORD);
        description_view.set_top_margin (8);
        description_view.set_bottom_margin (8);
        description_view.set_left_margin (8);
        description_view.set_right_margin (8);
        description_view.add_css_class ("card");

        scrolled.set_child (description_view);
        desc_box.append (scrolled);
        content.append (desc_box);

        var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
        button_box.set_halign (Gtk.Align.END);
        button_box.set_margin_top (10);
        button_box.set_homogeneous (true);

        var cancel_btn = new Gtk.Button.with_label ("Отмена");
        cancel_btn.add_css_class ("pill");
        cancel_btn.clicked.connect (() => this.close ());
        button_box.append (cancel_btn);

        add_button = new Gtk.Button.with_label ("Добавить");
        add_button.add_css_class ("suggested-action");
        add_button.add_css_class ("pill");
        add_button.sensitive = false;
        add_button.clicked.connect (on_add_clicked);
        button_box.append (add_button);

        content.append (button_box);

        this.set_content (content);
    }

    private void check_valid () {
        bool version_ok = version_entry.get_text ().strip () != "";
        bool date_ok = date_entry.get_text ().strip () != "";
        add_button.sensitive = version_ok && date_ok;
    }

    private void on_add_clicked () {
        var buffer = description_view.get_buffer ();
        Gtk.TextIter start, end;
        buffer.get_start_iter (out start);
        buffer.get_end_iter (out end);
        string description = buffer.get_text (start, end, false);

        var rel = new Release (
            version_entry.get_text (),
            date_entry.get_text (),
            description
        );
        release_added (rel);
        this.close ();
    }
}

}
