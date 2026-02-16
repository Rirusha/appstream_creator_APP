using Gee;

namespace AppstreamCreatorApp {

public class UrlGroup : Adw.PreferencesGroup {

    public signal void changed ();

    public Gtk.Entry homepage_entry { get; private set; }
    public Gtk.Entry bugtracker_entry { get; private set; }
    public Gtk.Entry donation_entry { get; private set; }
    public Gtk.Entry vcs_entry { get; private set; }

    public UrlGroup () {
        this.set_title ("Ссылки");
        this.set_description ("Веб-страницы проекта");

        var homepage_action_row = new Adw.ActionRow ();
        homepage_action_row.set_title ("Домашняя страница");
        homepage_action_row.set_subtitle ("https://example.org");

        homepage_entry = new Gtk.Entry ();
        homepage_entry.hexpand = true;
        homepage_entry.changed.connect (() => changed ());

        homepage_action_row.add_suffix (homepage_entry);
        homepage_action_row.set_activatable_widget (homepage_entry);
        this.add (homepage_action_row);

        var bugtracker_action_row = new Adw.ActionRow ();
        bugtracker_action_row.set_title ("Баг-трекер");
        bugtracker_action_row.set_subtitle ("Ссылка на систему отслеживания ошибок");

        bugtracker_entry = new Gtk.Entry ();
        bugtracker_entry.hexpand = true;
        bugtracker_entry.changed.connect (() => changed ());

        bugtracker_action_row.add_suffix (bugtracker_entry);
        bugtracker_action_row.set_activatable_widget (bugtracker_entry);
        this.add (bugtracker_action_row);

        var donation_action_row = new Adw.ActionRow ();
        donation_action_row.set_title ("Пожертвования");
        donation_action_row.set_subtitle ("Ссылка для поддержки проекта");

        donation_entry = new Gtk.Entry ();
        donation_entry.hexpand = true;
        donation_entry.changed.connect (() => changed ());

        donation_action_row.add_suffix (donation_entry);
        donation_action_row.set_activatable_widget (donation_entry);
        this.add (donation_action_row);

        var vcs_action_row = new Adw.ActionRow ();
        vcs_action_row.set_title ("Исходный код");
        vcs_action_row.set_subtitle ("Репозиторий (GitHub, GitLab и т.д.)");

        vcs_entry = new Gtk.Entry ();
        vcs_entry.hexpand = true;
        vcs_entry.changed.connect (() => changed ());

        vcs_action_row.add_suffix (vcs_entry);
        vcs_action_row.set_activatable_widget (vcs_entry);
        this.add (vcs_action_row);
    }

    public void update_data (AppstreamData data) {
        data.homepage = homepage_entry.get_text ();
        data.bugtracker = bugtracker_entry.get_text ();
        data.donation = donation_entry.get_text ();
        data.vcs = vcs_entry.get_text ();
    }

    public void load_data (AppstreamData new_data) {
        string hp = new_data.homepage;
        string bt = new_data.bugtracker;
        string dn = new_data.donation;
        string v = new_data.vcs;

        message ("  url_group: homepage='%s'", hp);
        message ("  url_group: bugtracker='%s'", bt);
        message ("  url_group: donation='%s'", dn);
        message ("  url_group: vcs='%s'", v);

        homepage_entry.set_text (hp);
        bugtracker_entry.set_text (bt);
        donation_entry.set_text (dn);
        vcs_entry.set_text (v);
    }
}

}
