namespace AppstreamCreatorApp {

public class Window : Adw.ApplicationWindow {
    private AppstreamData data;
    private Gtk.TextView xml_preview;
    private BasicInfoGroup basic_group;
    private LicenseGroup license_group;
    private DeveloperGroup dev_group;
    private DescriptionGroup desc_group;
    private UrlGroup url_group;
    private LaunchGroup launch_group;
    private CatGroup cat_group;
    private BrandingGroup branding_group;
    private RatingGroup rating_group;
    private ScreenshotGroup screenshot_group;
    private ReleaseGroup release_group;

    public Window (Gtk.Application app) {
        Object (application: app);
        this.data = new AppstreamData ();
    }

    construct {
        this.set_default_size (1100, 900);
        this.set_size_request (900, 700);

        var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        this.set_content (content);

        var header = new Adw.HeaderBar ();
        content.append (header);

        var open_btn = new Gtk.Button.with_label ("Открыть");
        open_btn.add_css_class ("pill");
        open_btn.clicked.connect (on_open_clicked);
        header.pack_start (open_btn);

        var generate_btn = new Gtk.Button.with_label ("Сгенерировать XML");
        generate_btn.add_css_class ("suggested-action");
        generate_btn.add_css_class ("pill");
        generate_btn.clicked.connect (on_generate_clicked);
        header.pack_end (generate_btn);

        var save_btn = new Gtk.Button.with_label ("Сохранить");
        save_btn.add_css_class ("pill");
        save_btn.clicked.connect (on_save_clicked);
        header.pack_end (save_btn);

        var scrolled = new Gtk.ScrolledWindow ();
        scrolled.set_vexpand (true);
        content.append (scrolled);

        var clamp = new Adw.Clamp ();
        scrolled.set_child (clamp);

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 20);
        main_box.set_margin_top (20);
        main_box.set_margin_bottom (20);
        main_box.set_margin_start (20);
        main_box.set_margin_end (20);
        clamp.set_child (main_box);

        basic_group = new BasicInfoGroup ();
        basic_group.changed.connect (update_data);
        main_box.append (basic_group);

        license_group = new LicenseGroup ();
        license_group.changed.connect (update_data);
        main_box.append (license_group);

        dev_group = new DeveloperGroup ();
        dev_group.changed.connect (update_data);
        main_box.append (dev_group);

        desc_group = new DescriptionGroup ();
        desc_group.changed.connect (update_data);
        main_box.append (desc_group);

        url_group = new UrlGroup ();
        url_group.changed.connect (update_data);
        main_box.append (url_group);

        launch_group = new LaunchGroup ();
        launch_group.changed.connect (update_data);
        main_box.append (launch_group);

        cat_group = new CatGroup ();
        cat_group.changed.connect (update_data);
        main_box.append (cat_group);

        branding_group = new BrandingGroup ();
        branding_group.changed.connect (update_data);
        main_box.append (branding_group);

        rating_group = new RatingGroup ();
        rating_group.changed.connect (update_data);
        main_box.append (rating_group);

        screenshot_group = new ScreenshotGroup ();
        screenshot_group.changed.connect (() => {
            data.screenshots = screenshot_group.get_screenshots ();
            update_data ();
        });
        screenshot_group.add_clicked.connect (() => {
            var dialog = new ScreenshotDialog (this);
            dialog.screenshot_added.connect ((shot) => {
                data.screenshots.add (shot);
                screenshot_group.add_screenshot (shot);
                update_data ();
            });
            dialog.present ();
        });
        main_box.append (screenshot_group);

        release_group = new ReleaseGroup ();
        release_group.changed.connect (() => {
            data.releases = release_group.get_releases ();
            update_data ();
        });
        release_group.add_clicked.connect (() => {
            var dialog = new ReleaseDialog (this);
            dialog.release_added.connect ((rel) => {
                data.releases.add (rel);
                release_group.add_release (rel);
                update_data ();
            });
            dialog.present ();
        });
        main_box.append (release_group);

        var preview_group = new Adw.PreferencesGroup ();
        preview_group.set_title ("Предпросмотр XML");
        preview_group.set_description ("Сгенерированный AppStream файл");
        main_box.append (preview_group);

        var preview_frame = new Gtk.Frame (null);
        preview_frame.add_css_class ("card");
        preview_frame.set_margin_top (10);
        preview_frame.set_margin_bottom (10);

        var preview_scrolled = new Gtk.ScrolledWindow ();
        preview_scrolled.set_size_request (-1, 300);
        preview_scrolled.set_vexpand (true);

        xml_preview = new Gtk.TextView ();
        xml_preview.set_editable (false);
        xml_preview.set_monospace (true);
        xml_preview.set_wrap_mode (Gtk.WrapMode.NONE);
        xml_preview.set_top_margin (10);
        xml_preview.set_bottom_margin (10);
        xml_preview.set_left_margin (10);
        xml_preview.set_right_margin (10);
        xml_preview.add_css_class ("xml-preview");

        preview_scrolled.set_child (xml_preview);
        preview_frame.set_child (preview_scrolled);
        preview_group.add (preview_frame);

        load_css ();

        update_data ();
    }

    private void update_data () {
        basic_group.update_data (data);
        license_group.update_data (data);
        dev_group.update_data (data);
        desc_group.update_data (data);
        url_group.update_data (data);
        launch_group.update_data (data);
        cat_group.update_data (data);
        branding_group.update_data (data);
        rating_group.update_data (data);

        generate_xml ();
    }

    private void generate_xml () {
        var errors = Validator.validate_all (data);
        if (errors.size > 0) {
            var error_text = new StringBuilder ();
            error_text.append ("ОШИБКИ ВАЛИДАЦИИ:\n");
            foreach (var err in errors) {
                error_text.append_printf ("• %s\n", err);
            }
            var buffer = new Gtk.TextBuffer (null);
            buffer.set_text (error_text.str, -1);
            xml_preview.set_buffer (buffer);
            return;
        }

        string xml = XmlGenerator.generate (data);
        var buffer = new Gtk.TextBuffer (null);
        buffer.set_text (xml, -1);
        xml_preview.set_buffer (buffer);
    }

    private void on_generate_clicked () {
        generate_xml ();
    }

    private void on_open_clicked () {
    var file_dialog = new Gtk.FileDialog ();
    file_dialog.set_title ("Открыть XML файл");

    var filters = new ListStore (typeof (Gtk.FileFilter));
    var filter = new Gtk.FileFilter ();
    filter.set_filter_name ("XML файлы");
    filter.add_pattern ("*.xml");
    filter.add_pattern ("*.metainfo.xml");
    filter.add_pattern ("*.appdata.xml");
    filters.append (filter);
    file_dialog.set_filters (filters);

    file_dialog.open.begin (this, null, (obj, res) => {
        try {
            var file = file_dialog.open.end (res);
            string file_path = file.get_path ();

            var loaded_data = FileLoader.load_from_file (file_path);
            if (loaded_data != null) {
                copy_data (loaded_data);

                message ("\n=== ДАННЫЕ ПОСЛЕ ЗАГРУЗКИ ===");
                message ("id = '%s'", data.id);
                message ("name = '%s'", data.name);
                message ("summary = '%s'", data.summary);

                message ("\n=== ВЫЗОВ МЕТОДОВ load_data ===");

                message ("→ basic_group.load_data()");
                basic_group.load_data (data);

                message ("→ license_group.load_data()");
                license_group.load_data (data);

                message ("→ dev_group.load_data()");
                dev_group.load_data (data);

                message ("→ desc_group.load_data()");
                desc_group.load_data (data);

                message ("→ url_group.load_data()");
                url_group.load_data (data);

                message ("→ launch_group.load_data()");
                launch_group.load_data (data);

                message ("→ cat_group.load_data()");
                cat_group.load_data (data);

                message ("→ branding_group.load_data()");
                branding_group.load_data (data);

                message ("→ rating_group.load_data()");
                rating_group.load_data (data);

                generate_xml ();

                var dialog = new Adw.AlertDialog (
                    "Успех",
                    "Файл загружен и поля заполнены!"
                );
                dialog.add_response ("ok", "OK");
                dialog.present (this);
            } else {
                var error_dialog = new Adw.AlertDialog (
                    "Ошибка",
                    "Не удалось загрузить файл: неправильный формат"
                );
                error_dialog.add_response ("ok", "OK");
                error_dialog.present (this);
            }

        } catch (Error e) {
            warning ("Ошибка загрузки: %s", e.message);
            var error_dialog = new Adw.AlertDialog (
                "Ошибка",
                "Не удалось загрузить файл: " + e.message
            );
            error_dialog.add_response ("ok", "OK");
            error_dialog.present (this);
        }
    });
}

private void copy_data (AppstreamData source) {
    data.id = source.id;
    data.name = source.name;
    data.summary = source.summary;
    data.metadata_license = source.metadata_license;
    data.project_license = source.project_license;
    data.developer_id = source.developer_id;
    data.developer_name = source.developer_name;
    data.description = source.description;
    data.homepage = source.homepage;
    data.bugtracker = source.bugtracker;
    data.donation = source.donation;
    data.vcs = source.vcs;
    data.launchable = source.launchable;
    data.categories = source.categories;
    data.keywords = source.keywords;
    data.light_color = source.light_color;
    data.dark_color = source.dark_color;
    data.use_content_rating = source.use_content_rating;

    data.screenshots.clear ();
    foreach (var shot in source.screenshots) {
        data.screenshots.add (shot);
    }

    data.releases.clear ();
    foreach (var rel in source.releases) {
        data.releases.add (rel);
    }
}
    private void on_save_clicked () {
        var file_dialog = new Gtk.FileDialog ();
        file_dialog.set_title ("Сохранить XML файл");
        file_dialog.set_initial_name ("metainfo.xml");

        file_dialog.save.begin (this, null, (obj, res) => {
            try {
                var file = file_dialog.save.end (res);
                var buffer = xml_preview.get_buffer ();
                Gtk.TextIter start, end;
                buffer.get_start_iter (out start);
                buffer.get_end_iter (out end);
                string xml_content = buffer.get_text (start, end, false);

                FileUtils.set_contents (file.get_path (), xml_content);
                var dialog = new Adw.AlertDialog (
                    "Успех",
                    "Файл сохранен!"
                );
                dialog.add_response ("ok", "OK");
                dialog.present (this);

            } catch (Error e) {
                warning ("Ошибка сохранения: %s", e.message);
                var error_dialog = new Adw.AlertDialog (
                    "Ошибка",
                    "Не удалось сохранить файл: " + e.message
                );
                error_dialog.add_response ("ok", "OK");
                error_dialog.present (this);
            }
        });
    }

    private void load_css () {
        var provider = new Gtk.CssProvider ();
        try {
            provider.load_from_resource ("/io/github/user/appstreamcreator/style/main.css");
            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        } catch (Error e) {
            warning ("CSS error: %s", e.message);
        }
    }
}

}
