using Gee;

namespace AppstreamCreatorApp {

public class Validator {

    public static string? validate_required (AppstreamData data) {
        if (data.id.strip () == "")
            return "ID приложения обязательно";
        if (data.name.strip () == "")
            return "Название обязательно";
        if (data.summary.strip () == "")
            return "Краткое описание обязательно";
        if (data.developer_id.strip () == "")
            return "ID разработчика обязательно";
        if (data.developer_name.strip () == "")
            return "Имя разработчика обязательно";
        if (data.description.strip () == "")
            return "Описание обязательно";
        if (data.homepage.strip () == "")
            return "Домашняя страница обязательна";
        return null;
    }

    public static bool is_valid_url (string url) {
        return url.has_prefix ("http://") || url.has_prefix ("https://");
    }

    public static bool is_valid_date (string date) {
        var regex = /^\d{4}-\d{2}-\d{2}$/;
        return regex.match (date);
    }

    public static Gee.ArrayList<string> validate_urls (AppstreamData data) {
        var errors = new Gee.ArrayList<string> ();
        if (data.homepage != "" && !is_valid_url (data.homepage))
            errors.add ("Домашняя страница должна начинаться с http:// или https://");
        if (data.bugtracker != "" && !is_valid_url (data.bugtracker))
            errors.add ("Баг-трекер должен начинаться с http:// или https://");
        if (data.donation != "" && !is_valid_url (data.donation))
            errors.add ("Ссылка для пожертвований должна начинаться с http:// или https://");
        if (data.vcs != "" && !is_valid_url (data.vcs))
            errors.add ("Репозиторий должен начинаться с http:// или https://");
        return errors;
    }

    public static Gee.ArrayList<string> validate_screenshots (Gee.ArrayList<Screenshot> screenshots) {
        var errors = new Gee.ArrayList<string> ();
        foreach (var shot in screenshots) {
            if (!is_valid_url (shot.url))
                errors.add ("URL скриншота должен начинаться с http:// или https://: " + shot.url);
        }
        return errors;
    }

    public static Gee.ArrayList<string> validate_releases (Gee.ArrayList<Release> releases) {
        var errors = new Gee.ArrayList<string> ();
        foreach (var release in releases) {
            if (release.version.strip () == "")
                errors.add ("Версия релиза не может быть пустой");
            if (!is_valid_date (release.date))
                errors.add ("Дата релиза должна быть в формате ГГГГ-ММ-ДД: " + release.date);
        }
        return errors;
    }

    public static Gee.ArrayList<string> validate_all (AppstreamData data) {
        var errors = new Gee.ArrayList<string> ();

        var required_error = validate_required (data);
        if (required_error != null)
            errors.add (required_error);

        errors.add_all (validate_urls (data));
        errors.add_all (validate_screenshots (data.screenshots));
        errors.add_all (validate_releases (data.releases));

        return errors;
    }
}

}
