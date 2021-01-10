# install_data(
#     'assets/icons/com.github.com.hmleal.crypto.bitcoin-btc.svg',
#     install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps'
# )

icons_dir = join_paths(get_option('datadir'), 'icons', 'hicolor')

install_data(
    join_paths('assets', 'icons', 'com.github.com.hmleal.crypto.btc.svg'),
    install_dir: join_paths(icons_dir , '32x32', 'status'),
)

install_data(
    join_paths('assets', 'icons', 'com.github.com.hmleal.crypto.eth.svg'),
    install_dir: join_paths(icons_dir , '32x32', 'status'),
)

install_data(
    join_paths('assets', 'icons', 'com.github.com.hmleal.crypto.bch.svg'),
    install_dir: join_paths(icons_dir , '32x32', 'status'),
)


resource_files = files ('file.gresource.xml')
resources = gnome.compile_resources ('com.github.hmleal.crypto',
                                     resource_files,
                                     c_name: 'resources',
                                     source_dir: ['data'])