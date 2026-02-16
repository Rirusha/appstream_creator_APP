using Gee;

namespace AppstreamCreatorApp {

public class Screenshot : Object {
    public string url { get; set; default = ""; }
    public string caption { get; set; default = ""; }
    public bool is_default { get; set; default = false; }

    public Screenshot (string url, string caption = "", bool is_default = false) {
        this.url = url;
        this.caption = caption;
        this.is_default = is_default;
    }
}

public class Release : Object {
    public string version { get; set; default = ""; }
    public string date { get; set; default = ""; }
    public string description { get; set; default = ""; }

    public Release (string version, string date, string description = "") {
        this.version = version;
        this.date = date;
        this.description = description;
    }
}

public class AppstreamData : Object {
    public string component_type { get; set; default = "desktop-application"; }
    public string id { get; set; default = ""; }
    public string name { get; set; default = ""; }
    public string summary { get; set; default = ""; }
    public string metadata_license { get; set; default = "CC0-1.0"; }
    public string project_license { get; set; default = ""; }
    public string developer_id { get; set; default = ""; }
    public string developer_name { get; set; default = ""; }
    public string description { get; set; default = ""; }
    public string homepage { get; set; default = ""; }
    public string bugtracker { get; set; default = ""; }
    public string donation { get; set; default = ""; }
    public string vcs { get; set; default = ""; }
    public string launchable { get; set; default = ""; }
    public string categories { get; set; default = ""; }
    public string keywords { get; set; default = ""; }
    public Gdk.RGBA light_color { get; set; default = { 0.55f, 0.37f, 0.98f, 1.0f }; }
    public Gdk.RGBA dark_color { get; set; default = { 0.36f, 0.13f, 0.85f, 1.0f }; }
    public bool use_content_rating { get; set; default = true; }
    public Gee.ArrayList<Screenshot> screenshots { get; set; default = new Gee.ArrayList<Screenshot> (); }
    public Gee.ArrayList<Release> releases { get; set; default = new Gee.ArrayList<Release> (); }

    public AppstreamData () {
    }
}

}
