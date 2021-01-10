class Crypto.Layouts.HeaderBar : Gtk.HeaderBar {

    public HeaderBar () {
        title = "Crypto";
        subtitle = "Find and track your digital coins";

        set_show_close_button (true);

        build_ui ();
    }

    private void build_ui () {
        var btn_add = new Gtk.Button.with_label ("Add");
        var btn_image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.BUTTON);

        var btn_settings = new Gtk.MenuButton ();
            btn_settings.set_image (btn_image);

        var builder = new Gtk.Builder.from_resource ("/ui/menus.ui");
        MenuModel menu = (MenuModel) builder.get_object ("app-menu");
        btn_settings.popover = new Gtk.Popover.from_model (btn_settings, menu);

        pack_start (btn_add);
        pack_end (btn_settings);
    }
}
