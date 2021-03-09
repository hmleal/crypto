# Create a new executable, list the files we want to compile, list the
# dependencies we need, and install
executable(
    meson.project_name(),

    'Application.vala',

    'Layouts/HeaderBar.vala',

    resources,

    dependencies: [
        dependency ('gtk+-3.0'),
        dependency ('json-glib-1.0'),
        dependency ('libsoup-2.4', version: '>= 2.38'),
    ],
    install: true
)
