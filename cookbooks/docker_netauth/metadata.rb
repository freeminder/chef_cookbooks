name 'docker_netauth'
maintainer 'Dmitry Zhukov'
maintainer_email 'dmitry.zhukov@gmail.com'
license 'Apache 2.0'
description 'Configures base and docker components for server.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

supports 'ubuntu'
supports 'debian'
supports 'redhat'
supports 'centos'
supports 'scientific'
supports 'amazon'
supports 'fedora'

depends  'docker', '>= 0.40.1'
