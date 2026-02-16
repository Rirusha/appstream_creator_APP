sources = files(
  'main.vala',
  'application.vala',
  'window.vala',
  'models/appstream_data.vala',
  'utils/xml_generator.vala',
  'utils/validator.vala',
  'utils/file_loader.vala',
  'dialogs/screenshot_dialog.vala',
  'dialogs/release_dialog.vala',
  'widgets/basic_info_group.vala',
  'widgets/license_group.vala',
  'widgets/developer_group.vala',
  'widgets/description_group.vala',
  'widgets/url_group.vala',
  'widgets/launch_group.vala',
  'widgets/cat_group.vala',
  'widgets/branding_group.vala',
  'widgets/rating_group.vala',
  'widgets/screenshot_group.vala',
  'widgets/release_group.vala'
)

deps = [
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('libxml-2.0'),
  dependency('gee-0.8')
]

executable('appstream_creator_app', sources,
  dependencies: deps,
  install: true
)