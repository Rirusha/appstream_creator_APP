using Gee;

namespace AppstreamCreatorApp {

public class RatingGroup : Adw.PreferencesGroup {

    public signal void changed ();

    public Gtk.Switch rating_switch { get; private set; }

    public RatingGroup () {
        this.set_title ("Возрастной рейтинг");
        this.set_description ("OARS - Open Age Ratings Service");

        var rating_row = new Adw.ActionRow ();
        rating_row.set_title ("Использовать OARS");
        rating_row.set_subtitle ("Добавить возрастной рейтинг");

        rating_switch = new Gtk.Switch ();
        rating_switch.set_active (true);
        rating_switch.set_valign (Gtk.Align.CENTER);
        rating_switch.notify["active"].connect (() => changed ());

        rating_row.add_suffix (rating_switch);
        rating_row.set_activatable_widget (rating_switch);
        this.add (rating_row);
    }

    public void update_data (AppstreamData data) {
        data.use_content_rating = rating_switch.get_active ();
    }

    public void load_data (AppstreamData new_data) {
        bool rating_val = new_data.use_content_rating;

        message ("  rating_group: use_content_rating=%s", rating_val.to_string ());
        rating_switch.set_active (rating_val);
    }
}

}
