project('svgvi', ['c', 'vala'],        version: '1.0.0',
  meson_version: '>= 0.40.0',
)

i18n = import('i18n')

cc = meson.get_compiler('c')
libmath = cc.find_library('m')

subdir('data')
subdir('src')
subdir('po')


meson.add_install_script('build-aux/meson/postinstall.py')