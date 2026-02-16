namespace AppstreamCreatorApp {

public class Application : Adw.Application {
    public Application () {
        Object (
            application_id: "io.github.user.appstreamcreator",
            flags: ApplicationFlags.DEFAULT_FLAGS
        );
    }

    public override void activate () {
        var win = new Window (this);
        win.present ();
    }
}

}
