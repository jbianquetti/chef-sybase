maintainer       "Jorge Bianquetti"
maintainer_email "jbianquetti@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures Sybase ASE"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends          "ark"
depends          "selinux"

recipe           "sybase::install1503","Install and builds Sybase ASE 15.0.3 "


%w{ centos redhat fedora }.each do |os|
  supports os
end

