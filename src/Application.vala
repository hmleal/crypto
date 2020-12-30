public class CoinHeaderBar : Gtk.HeaderBar {
    construct {
        title = "Crypto";
        subtitle = "Find and track your digital coins";

        show_close_button = true;

        var add_button = new Gtk.Button.with_label ("Add");
        var settings_button = new Gtk.Button.from_icon_name ("open-menu");

        pack_start (add_button);
        pack_end (settings_button);
    }
}

public class CoinWidget : Gtk.ListBoxRow {
    public Gtk.Box main_box;

    public CoinWidget (string icon_name) {
        main_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        main_box.margin = 12;

        var coin_name = new Gtk.Label ("Bitcoin");
            coin_name.halign = Gtk.Align.START;
        var coin_abbr = new Gtk.Label ("BTC");
            coin_abbr.halign = Gtk.Align.START;

        var coin_price = new Gtk.Label ("$ 230.04");
            coin_price.halign = Gtk.Align.END;
        var coin_percentage = new Gtk.Label ("+ 0.79%");
            coin_percentage.halign = Gtk.Align.END;

        var coin_image = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.LARGE_TOOLBAR);
            coin_image.halign = Gtk.Align.START;

        var coin_name_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            coin_name_box.spacing = 6;
            coin_name_box.add (coin_name);
            coin_name_box.add (coin_abbr);

        var coin_price_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            coin_price_box.spacing = 6;
            coin_price_box.add (coin_price);
            coin_price_box.add (coin_percentage);

        main_box.pack_start (coin_image, false, false, 6);
        main_box.pack_start (coin_name_box, false, false, 6);
        main_box.pack_end (coin_price_box, false);

        add (main_box);
    }
}


public class Crypto : Gtk.Application {
    public Crypto () {
        Object (
            application_id: "com.github.hmleal.crypto",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        Gtk.ApplicationWindow window = new Gtk.ApplicationWindow (this);

        window.set_default_size (600, 500);
        window.window_position = Gtk.WindowPosition.CENTER;
        window.set_titlebar (new CoinHeaderBar ());

        var mainBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            mainBox.valign = Gtk.Align.START;
            mainBox.get_style_context ().add_class ("frame");

            mainBox.margin = 32;

        string[] coins = {
            "com.github.com.hmleal.crypto.bitcoin-btc",
            "com.github.com.hmleal.crypto.bitcoin-cash-bch",
            "com.github.com.hmleal.crypto.ethereum-eth",
        };

        var listBox = new Gtk.ListBox ();
            listBox.set_header_func (use_list_box_separator);

        foreach (string coin in coins) {
            listBox.insert (new CoinWidget (coin), -1);
        }

        mainBox.pack_start (listBox);

        window.add (mainBox);
        window.show_all ();
    }

    public void use_list_box_separator (Gtk.ListBoxRow row, Gtk.ListBoxRow? before_row) {
        if (before_row == null) {
            row.set_header (null);

            return;
        }

        var current = row.get_header ();
        if (current == null) {
            current = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            current.visible = true;

            row.set_header (current);
        }
    }

    public static int main (string[] args) {
        Crypto app = new Crypto ();
        return app.run (args);
    }
}