using Gee;

namespace AppstreamCreatorApp {

public class CatGroup : Adw.PreferencesGroup {

    public signal void changed ();

    public Gtk.Entry categories_entry { get; private set; }
    public Gtk.Entry keywords_entry { get; private set; }

    public CatGroup () {
        this.set_title ("Категории и ключевые слова");
        this.set_description ("Для поиска в магазинах приложений");

        var cat_action_row = new Adw.ActionRow ();
        cat_action_row.set_title ("Категории");
        cat_action_row.set_subtitle ("Через запятую: Development, Game, Graphics");

        categories_entry = new Gtk.Entry ();
        categories_entry.hexpand = true;
        categories_entry.changed.connect (() => changed ());

        cat_action_row.add_suffix (categories_entry);
        cat_action_row.set_activatable_widget (categories_entry);
        this.add (cat_action_row);

        var keyword_action_row = new Adw.ActionRow ();
        keyword_action_row.set_title ("Ключевые слова");
        keyword_action_row.set_subtitle ("Через запятую: editor, text, writing");

        keywords_entry = new Gtk.Entry ();
        keywords_entry.hexpand = true;
        keywords_entry.changed.connect (() => changed ());

        keyword_action_row.add_suffix (keywords_entry);
        keyword_action_row.set_activatable_widget (keywords_entry);
        this.add (keyword_action_row);
    }

    public void update_data (AppstreamData data) {
        data.categories = categories_entry.get_text ();
        data.keywords = keywords_entry.get_text ();
    }

    public void load_data (AppstreamData new_data) {
        string cat_val = new_data.categories;
        string key_val = new_data.keywords;

        message ("  cat_group: categories='%s'", cat_val);
        message ("  cat_group: keywords='%s'", key_val);

        categories_entry.set_text (cat_val);
        keywords_entry.set_text (key_val);
    }
}

}
