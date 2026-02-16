using Gee;

namespace AppstreamCreatorApp {

public class DescriptionGroup : Adw.PreferencesGroup {

    public signal void changed ();

    public Gtk.TextView description_view { get; private set; }

    public DescriptionGroup () {
        this.set_title ("Описание");
        this.set_description ("Полное описание приложения");

        var description_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        description_box.set_margin_top (10);
        description_box.set_margin_bottom (10);
        description_box.set_margin_start (10);
        description_box.set_margin_end (10);

        description_view = new Gtk.TextView ();
        description_view.set_wrap_mode (Gtk.WrapMode.WORD);
        description_view.set_top_margin (10);
        description_view.set_bottom_margin (10);
        description_view.set_left_margin (10);
        description_view.set_right_margin (10);
        description_view.set_size_request (-1, 150);
        description_view.add_css_class ("card");
        description_view.buffer.changed.connect (() => changed ());

        description_box.append (description_view);

        var description_note = new Gtk.Label ("Поддерживаются параграфы (разделяйте пустой строкой)");
        description_note.add_css_class ("caption");
        description_note.set_halign (Gtk.Align.START);
        description_box.append (description_note);

        this.add (description_box);
    }

    public void update_data (AppstreamData data) {
        var buffer = description_view.get_buffer ();
        Gtk.TextIter start, end;
        buffer.get_start_iter (out start);
        buffer.get_end_iter (out end);
        data.description = buffer.get_text (start, end, false);
    }

    public void load_data (AppstreamData new_data) {
        string desc_val = new_data.description;

        message ("  desc_group: description='%s'", desc_val);
        var buffer = description_view.get_buffer ();
        buffer.set_text (desc_val, -1);
    }
}

}
