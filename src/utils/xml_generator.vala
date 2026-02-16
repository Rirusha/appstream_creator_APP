namespace AppstreamCreatorApp {

public class XmlGenerator {

    public static string generate (AppstreamData data) {
        var xml = new StringBuilder ();

        xml.append ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        xml.append_printf ("<component type=\"%s\">\n", escape_xml (data.component_type));

        if (data.id != "")
            xml.append_printf ("  <id>%s</id>\n", escape_xml (data.id));

        if (data.name != "")
            xml.append_printf ("  <name>%s</name>\n", escape_xml (data.name));

        if (data.summary != "")
            xml.append_printf ("  <summary>%s</summary>\n", escape_xml (data.summary));

        xml.append_printf ("  <metadata_license>%s</metadata_license>\n",
                          escape_xml (data.metadata_license));

        if (data.project_license != "") {
            xml.append_printf ("  <project_license>%s</project_license>\n",
                              escape_xml (data.project_license));
        }

        if (data.developer_name != "" || data.developer_id != "") {
            xml.append_printf ("  <developer id=\"%s\">\n",
                              escape_xml (data.developer_id != "" ? data.developer_id : "unknown"));
            xml.append_printf ("    <name>%s</name>\n",
                              escape_xml (data.developer_name != "" ? data.developer_name : "Unknown"));
            xml.append ("  </developer>\n");
        }

        if (data.description.strip () != "") {
            xml.append ("  <description>\n");
            string[] paragraphs = data.description.split ("\n\n");
            foreach (string para in paragraphs) {
                if (para.strip () != "") {
                    xml.append_printf ("    <p>%s</p>\n", escape_xml (para.strip ()));
                }
            }
            xml.append ("  </description>\n");
        }

        if (data.homepage != "")
            xml.append_printf ("  <url type=\"homepage\">%s</url>\n", escape_xml (data.homepage));
        if (data.bugtracker != "")
            xml.append_printf ("  <url type=\"bugtracker\">%s</url>\n", escape_xml (data.bugtracker));
        if (data.donation != "")
            xml.append_printf ("  <url type=\"donation\">%s</url>\n", escape_xml (data.donation));
        if (data.vcs != "")
            xml.append_printf ("  <url type=\"vcs-browser\">%s</url>\n", escape_xml (data.vcs));

        if (data.launchable != "") {
            xml.append_printf ("  <launchable type=\"desktop-id\">%s</launchable>\n",
                              escape_xml (data.launchable));
        }

        if (data.categories != "") {
            xml.append ("  <categories>\n");
            string[] categories = data.categories.split (",");
            foreach (string cat in categories) {
                string cat_trim = cat.strip ();
                if (cat_trim != "") {
                    xml.append_printf ("    <category>%s</category>\n", escape_xml (cat_trim));
                }
            }
            xml.append ("  </categories>\n");
        }

        if (data.keywords != "") {
            xml.append ("  <keywords>\n");
            string[] keywords = data.keywords.split (",");
            foreach (string kw in keywords) {
                string kw_trim = kw.strip ();
                if (kw_trim != "") {
                    xml.append_printf ("    <keyword>%s</keyword>\n", escape_xml (kw_trim));
                }
            }
            xml.append ("  </keywords>\n");
        }

        string light_str = data.light_color.to_string ();
        string dark_str = data.dark_color.to_string ();
        if (light_str != "#000000ff" || dark_str != "#000000ff") {
            xml.append ("  <branding>\n");
            xml.append_printf ("    <color type=\"primary\" scheme_preference=\"light\">#%02x%02x%02x</color>\n",
                (int)(data.light_color.red * 255),
                (int)(data.light_color.green * 255),
                (int)(data.light_color.blue * 255));
            xml.append_printf ("    <color type=\"primary\" scheme_preference=\"dark\">#%02x%02x%02x</color>\n",
                (int)(data.dark_color.red * 255),
                (int)(data.dark_color.green * 255),
                (int)(data.dark_color.blue * 255));
            xml.append ("  </branding>\n");
        }

        if (data.screenshots.size > 0) {
            xml.append ("  <screenshots>\n");
            foreach (var shot in data.screenshots) {
                xml.append_printf ("    <screenshot%s>\n",
                                  shot.is_default ? " type=\"default\"" : "");
                if (shot.caption != "")
                    xml.append_printf ("      <caption>%s</caption>\n", escape_xml (shot.caption));
                xml.append_printf ("      <image>%s</image>\n", escape_xml (shot.url));
                xml.append ("    </screenshot>\n");
            }
            xml.append ("  </screenshots>\n");
        }

        if (data.releases.size > 0) {
            xml.append ("  <releases>\n");
            foreach (var release in data.releases) {
                xml.append_printf ("    <release version=\"%s\" date=\"%s\">\n",
                                  escape_xml (release.version), escape_xml (release.date));
                if (release.description.strip () != "") {
                    xml.append ("      <description>\n");
                    xml.append_printf ("        <p>%s</p>\n", escape_xml (release.description));
                    xml.append ("      </description>\n");
                }
                xml.append ("    </release>\n");
            }
            xml.append ("  </releases>\n");
        }

        if (data.use_content_rating) {
            xml.append ("  <content_rating type=\"oars-1.1\" />\n");
        }

        xml.append ("</component>");

        return xml.str;
    }

    private static string escape_xml (string text) {
        return text.replace ("&", "&amp;")
                   .replace ("<", "&lt;")
                   .replace (">", "&gt;")
                   .replace ("\"", "&quot;")
                   .replace ("'", "&apos;");
    }
}

}
