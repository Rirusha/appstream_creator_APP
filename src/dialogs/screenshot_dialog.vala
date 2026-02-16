namespace AppstreamCreatorApp {

public class ScreenshotDialog : Adw.Window {

    public signal void screenshot_added (Screenshot shot);

    private Gtk.Entry url_entry;
    private Gtk.Entry caption_entry;
    private Gtk.CheckButton default_check;
    private Gtk.Button add_button;

    public ScreenshotDialog (Gtk.Window parent) {
        this.set_transient_for (parent);
        this.set_modal (true);
        this.set_title ("Добавить скриншот");
        this.set_default_size (400, 300);

        var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 20);
        content.set_margin_top (20);
        content.set_margin_bottom (20);
        content.set_margin_start (20);
        content.set_margin_end (20);


        var title = new Gtk.Label ("");
        title.set_markup ("<big><b>Новый скриншот</b></big>");
        title.set_halign (Gtk.Align.CENTER);
        content.append (title);


        var url_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        var url_label = new Gtk.Label ("URL изображения *");
        url_label.set_halign (Gtk.Align.START);
        url_label.add_css_class ("heading");
        url_box.append (url_label);

        url_entry = new Gtk.Entry ();
        url_entry.set_placeholder_text ("https://example.org/shot.png");
        url_entry.set_hexpand (true);
        url_box.append (url_entry);
        content.append (url_box);

        var caption_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        var caption_label = new Gtk.Label ("Подпись");
        caption_label.set_halign (Gtk.Align.START);
        caption_label.add_css_class ("heading");
        caption_box.append (caption_label);

        caption_entry = new Gtk.Entry ();
        caption_entry.set_placeholder_text ("Главное окно приложения");
        caption_entry.set_hexpand (true);
        caption_box.append (caption_entry);
        content.append (caption_box);

        default_check = new Gtk.CheckButton.with_label ("Использовать как скриншот по умолчанию");
        content.append (default_check);

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

        url_entry.changed.connect (() => {
            add_button.sensitive = url_entry.get_text ().strip () != "";
        });

        this.set_content (content);
    }

    private void on_add_clicked () {
        var shot = new Screenshot (
            url_entry.get_text (),
            caption_entry.get_text (),
            default_check.get_active ()
        );
        screenshot_added (shot);
        this.close ();
    }
}

}
