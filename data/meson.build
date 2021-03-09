# install_data(
#     'assets/icons/com.github.com.hmleal.crypto.bitcoin-btc.svg',
#     install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps'
# )

icons_dir = join_paths(get_option('datadir'), 'icons', 'hicolor')

install_data(
    join_paths('assets', 'icons', 'com.github.com.hmleal.svg'),
    install_dir: join_paths(icons_dir / 'scalable' / 'apps'),
)

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

prefix = get_option('prefix')

datadir = prefix / get_option('datadir')


# Desktop file
desktop_conf = configuration_data()
desktop_conf.set('icon', 'com.github.com.hmleal')
desktop_file = i18n.merge_file(
  type: 'desktop',
  input: configure_file(
    input: '@0@.desktop.in.in'.format('com.github.com.hmleal'),
    output: '@BASENAME@',
    configuration: desktop_conf
  ),
  output: '@0@.desktop'.format('com.github.com.hmleal'),
  po_dir: join_paths(meson.source_root(), 'po'),
  install: true,
  install_dir: join_paths(get_option('datadir'), 'applications')
)

resource_files = files ('file.gresource.xml')
resources = gnome.compile_resources ('com.github.hmleal.crypto',
                                     resource_files,
                                     c_name: 'resources',
                                     source_dir: ['data'])