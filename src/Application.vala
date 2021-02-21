public class Coin {

    public string name;
    public string abbr;

    public double value;  // price

    public Coin (string name, string abbr, double value) {
        this.name = name;
        this.abbr = abbr;

        this.value = value;
    }

    public string get_value () {
        char[] buf = new char[double.DTOSTR_BUF_SIZE];

        return this.value.format (buf, "%.2f");
    }
}

public class CoinService {

    public signal void request_prices_success (List<Coin> coins);

    public void request_price () {
        // https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH&tsyms=EUR

        Soup.Session session = new Soup.Session ();
        Soup.Message message = new Soup.Message ("GET", "https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,BCH&tsyms=EUR");

        session.queue_message (message, (sess, mess) => {
            if (message.status_code == 200) {
                var parser = new Json.Parser ();

                try {
                    parser.load_from_data ((string) mess.response_body.flatten ().data, -1);

                    var coin_list = new List<Coin> ();

                    var root = parser.get_root ();
                    var root_object = root.get_object ();

                    foreach (unowned string name in root_object.get_members ()) {
                        unowned Json.Node item = root_object.get_member (name);

                        var coin_name = "";
                        switch (name) {
                            case "BTC":
                                coin_name = "Bitcoin";
                                break;
                            case "ETH":
                                coin_name = "Ethereum";
                                break;
                            case "BCH":
                                coin_name = "Bitcoin Cash";
                                break;
                        }

                        var coin_value = process_coin (item);

                        coin_list.append (new Coin (coin_name, name, coin_value) );

                    }
                    request_prices_success (coin_list);

                } catch (Error e) {
                }
            }
        });

    }

    public double process_coin (Json.Node node) {
        unowned Json.Object obj = node.get_object ();

        return obj.get_double_member ("EUR");
    }
}

public class CoinWidget : Gtk.ListBoxRow {
    public Gtk.Box main_box;
    private string icon_name;

    public CoinWidget (Coin coin) {

        this.icon_name = "com.github.com.hmleal.crypto." + coin.abbr.down ();

        visible = true;

        main_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        main_box.margin = 12;
        main_box.visible = true;

        var coin_name = new Gtk.Label (coin.name);
            coin_name.halign = Gtk.Align.START;
            coin_name.visible = true;

            coin_name.get_style_context ().add_class ("coin-title");

        var coin_abbr = new Gtk.Label (coin.abbr);
            coin_abbr.halign = Gtk.Align.START;
            coin_abbr.visible = true;

            coin_abbr.get_style_context ().add_class ("coin-abbr");

        var coin_price = new Gtk.Label ("€ " + coin.get_value ());
            coin_price.halign = Gtk.Align.END;
            coin_price.visible = true;

        var coin_percentage = new Gtk.Label ("+ 0.79%");
            coin_percentage.halign = Gtk.Align.END;
            coin_percentage.visible = true;

        var coin_image = new Gtk.Image.from_icon_name (this.icon_name, Gtk.IconSize.LARGE_TOOLBAR);
            coin_image.halign = Gtk.Align.START;
            coin_image.visible = true;

        var coin_name_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            coin_name_box.spacing = 6;
            coin_name_box.visible = true;
            coin_name_box.add (coin_name);
            coin_name_box.add (coin_abbr);

        var coin_price_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            coin_price_box.spacing = 6;
            coin_price_box.visible = true;
            coin_price_box.add (coin_price);
            coin_price_box.add (coin_percentage);

        main_box.pack_start (coin_image, false, false, 6);
        main_box.pack_start (coin_name_box, false, false, 6);
        main_box.pack_end (coin_price_box, false);

        add (main_box);
    }

    //  private void build_ui () {}
}

public class CryptoApp : Gtk.Application {

    private CoinService coin_service;

    public CryptoApp () {
        Object (
            application_id: "com.github.hmleal.crypto",
            flags: ApplicationFlags.FLAGS_NONE
        );

        this.coin_service = new CoinService ();
    }

    protected override void activate () {
        Gtk.ApplicationWindow window = new Gtk.ApplicationWindow (this);

        window.set_default_size (600, 500);
        window.set_titlebar (new Crypto.Layouts.HeaderBar ());

        window.window_position = Gtk.WindowPosition.CENTER;

        Gtk.CssProvider css_provider = new Gtk.CssProvider ();
        css_provider.load_from_resource ("stylesheet.css");

        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            main_box.valign = Gtk.Align.START;
            main_box.get_style_context ().add_class ("frame");

            main_box.margin = 32;

        var list_box = new Gtk.ListBox ();
            list_box.set_header_func (use_list_box_separator);

        coin_service.request_price ();
        coin_service.request_prices_success.connect ((coins) => {
            foreach (var coin in coins) {
                list_box.insert (new CoinWidget (coin), -1);
            }
        });

        var action = new GLib.SimpleAction ("about", null);
        action.activate.connect (() => {
            string[] authors = {
                "Henrique Leal <hmleal@hotmail.com>",
            };
            string[] artists = {
                "Henrique Leal <hmleal@hotmail.com>"
            };
            // Move to a different file
            Gtk.show_about_dialog (window,
                                   "artists", artists,
                                   "authors", authors,
                                   "translator-credits", "translator-credits",
                                   "comments", "A simple GNOME 3 application to track cryptocurrencies",
                                   "copyright", "\xc2\xa9 2020-2021 Henrique Leal",
                                   "license-type", Gtk.License.LGPL_2_1,
                                   "program-name", "Crypto",
                                   "logo-icon-name", "LOGO",
                                   "version", "0.0.2",
                                   "website", "",
                                   "wrap-license", true);
        });

        add_action (action);

        main_box.pack_start (list_box);

        window.add (main_box);
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
        CryptoApp app = new CryptoApp ();
        return app.run (args);
    }
}
