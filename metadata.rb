maintainer       "Jorge Bianquetti"
maintainer_email "jbianquetti@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures sybase"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
depends          "ark"
recipe           "sybase::install","Install and builds Sybase ASE"
