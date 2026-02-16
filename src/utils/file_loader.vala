using Gee;
using Xml;

namespace AppstreamCreatorApp {

public class FileLoader {

    public static AppstreamData? load_from_file (string file_path) {
        var data = new AppstreamData ();

        Xml.Parser.init ();
        message ("Начинаем загрузку файла: %s", file_path);

        Xml.Doc* doc = Xml.Parser.parse_file (file_path);
        if (doc == null) {
            warning ("Не удалось загрузить файл: %s", file_path);
            return null;
        }

        Xml.Node* root = doc->get_root_element ();
        if (root == null) {
            message ("Корневой элемент не найден");
            delete doc;
            return null;
        }

        if (root->type == Xml.ElementType.ELEMENT_NODE && root->name == "component") {
            message ("Найден корневой элемент <component>");

            var type_attr = root->get_prop ("type");
            if (type_attr != null) {
                data.component_type = type_attr;
                message ("  type = %s", type_attr);
            }

            for (Xml.Node* node = root->children; node != null; node = node->next) {
                if (node->type == Xml.ElementType.ELEMENT_NODE) {
                    parse_node (node, data);
                }
            }
        } else {
            message ("Корневой элемент не <component>, а %s", root->name);
        }

        delete doc;
        Xml.Parser.cleanup ();

        message ("Загружены данные:");
        message ("  id = %s", data.id);
        message ("  name = %s", data.name);
        message ("  summary = %s", data.summary);
        message ("  metadata_license = %s", data.metadata_license);
        message ("  project_license = %s", data.project_license);
        message ("  developer_id = %s", data.developer_id);
        message ("  developer_name = %s", data.developer_name);
        message ("  homepage = %s", data.homepage);
        message ("  use_content_rating = %s", data.use_content_rating.to_string ());

        return data;
    }

    private static void parse_node (Xml.Node* node, AppstreamData data) {
        string name = node->name;
        string? content = node->get_content ();

        if (content == null) {
            message ("  Элемент %s: нет содержимого", name);
            return;
        }

        message ("  Парсинг <%s> = '%s'", name, content);

        switch (name) {
            case "id":
                data.id = content;
                break;
            case "name":
                data.name = content;
                break;
            case "summary":
                data.summary = content;
                break;
            case "metadata_license":
                data.metadata_license = content;
                break;
            case "project_license":
                data.project_license = content;
                break;
            case "description":
                parse_description (node, data);
                break;
            case "developer":
                parse_developer (node, data);
                break;
            case "url":
                parse_url (node, data);
                break;
            case "launchable":
                data.launchable = content;
                message ("    launchable = %s", content);
                break;
            case "categories":
                parse_categories (node, data);
                break;
            case "keywords":
                parse_keywords (node, data);
                break;
            case "branding":
                parse_branding (node, data);
                break;
            case "content_rating":
                data.use_content_rating = true;
                message ("    use_content_rating = true");
                break;
            case "screenshots":
                parse_screenshots (node, data);
                break;
            case "releases":
                parse_releases (node, data);
                break;
            default:
                message ("    Неизвестный тег: %s", name);
                break;
        }
    }

    private static void parse_description (Xml.Node* node, AppstreamData data) {
        var desc = new StringBuilder ();
        for (Xml.Node* child = node->children; child != null; child = child->next) {
            if (child->type == Xml.ElementType.ELEMENT_NODE && child->name == "p") {
                string? p_content = child->get_content ();
                if (p_content != null) {
                    if (desc.len > 0)
                        desc.append ("\n\n");
                    desc.append (p_content.strip ());
                    message ("    description p: %s", p_content);
                }
            }
        }
        data.description = desc.str;
    }

    private static void parse_developer (Xml.Node* node, AppstreamData data) {
        var id_attr = node->get_prop ("id");
        if (id_attr != null) {
            data.developer_id = id_attr;
            message ("    developer id = %s", id_attr);
        }

        for (Xml.Node* child = node->children; child != null; child = child->next) {
            if (child->type == Xml.ElementType.ELEMENT_NODE && child->name == "name") {
                string? name = child->get_content ();
                if (name != null) {
                    data.developer_name = name;
                    message ("    developer name = %s", name);
                }
                break;
            }
        }
    }

    private static void parse_url (Xml.Node* node, AppstreamData data) {
        var type_attr = node->get_prop ("type");
        if (type_attr == null) {
            message ("    url без типа, пропускаем");
            return;
        }

        string? content = node->get_content ();
        if (content == null) {
            message ("    url типа %s без содержимого", type_attr);
            return;
        }

        message ("    url типа %s = %s", type_attr, content);

        switch (type_attr) {
            case "homepage":
                data.homepage = content;
                break;
            case "bugtracker":
                data.bugtracker = content;
                break;
            case "donation":
                data.donation = content;
                break;
            case "vcs-browser":
                data.vcs = content;
                break;
            default:
                message ("    неизвестный тип url: %s", type_attr);
                break;
        }
    }

    private static void parse_categories (Xml.Node* node, AppstreamData data) {
        var cats = new ArrayList<string> ();
        for (Xml.Node* child = node->children; child != null; child = child->next) {
            if (child->type == Xml.ElementType.ELEMENT_NODE && child->name == "category") {
                string? cat = child->get_content ();
                if (cat != null) {
                    cats.add (cat.strip ());
                    message ("    category = %s", cat);
                }
            }
        }
        if (cats.size > 0) {
            data.categories = string.joinv (", ", cats.to_array ());
            message ("    categories = %s", data.categories);
        }
    }

    private static void parse_keywords (Xml.Node* node, AppstreamData data) {
        var keys = new ArrayList<string> ();
        for (Xml.Node* child = node->children; child != null; child = child->next) {
            if (child->type == Xml.ElementType.ELEMENT_NODE && child->name == "keyword") {
                string? key = child->get_content ();
                if (key != null) {
                    keys.add (key.strip ());
                    message ("    keyword = %s", key);
                }
            }
        }
        if (keys.size > 0) {
            data.keywords = string.joinv (", ", keys.to_array ());
            message ("    keywords = %s", data.keywords);
        }
    }

    private static void parse_branding (Xml.Node* node, AppstreamData data) {
        for (Xml.Node* child = node->children; child != null; child = child->next) {
            if (child->type == Xml.ElementType.ELEMENT_NODE && child->name == "color") {
                var scheme = child->get_prop ("scheme_preference");
                string? color_str = child->get_content ();

                if (scheme != null && color_str != null && color_str[0] == '#') {
                    Gdk.RGBA color = { 0, 0, 0, 1 };
                    if (color_str.length >= 7) {
                        color.red = ((int) ("0x" + color_str[1:3]).to_long (null, 0)) / 255.0f;
                        color.green = ((int) ("0x" + color_str[3:5]).to_long (null, 0)) / 255.0f;
                        color.blue = ((int) ("0x" + color_str[5:7]).to_long (null, 0)) / 255.0f;
                        message ("    color %s = %s -> rgba(%.2f,%.2f,%.2f)", scheme, color_str, color.red, color.green, color.blue);
                    }

                    if (scheme == "light")
                        data.light_color = color;
                    else if (scheme == "dark")
                        data.dark_color = color;
                }
            }
        }
    }

    private static void parse_screenshots (Xml.Node* node, AppstreamData data) {
        message ("    screenshots (парсинг отключен)");
    }

    private static void parse_releases (Xml.Node* node, AppstreamData data) {
        message ("    releases (парсинг отключен)");
    }
}

}
