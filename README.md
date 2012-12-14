CHEF-SYBASE
===========
Sybase Chef cookbook
Install, build and manages Adaptive Server Enterprise  

CAUTION
==========
This repo is under heavy development only over Red Hat's family 
At this time, only has been tested with CentOS 6.3 and Sybase ASE 15.0.3, but 
diferents Sybase versions have diferent installers name, options, ....
To customize, look for  "installing sybase" command  in recipe/install.rb 

If you logs with sybase user,  execute "source ~/SYBASE.sh" before any further actions
After that, if you still have problems when executing "isql", these are caused by LANG environment settings
Use LANG=C and every works again.

USE
==========

Use sybase::install1503 to install Sybase 15.0.3 :  Recipe install1503.rb 
Use sybase::install157  to install Sybase 15.7   :  Recipe install157.rb


TODO
==========
 
* build default attributes (DONE)
* add recipe's dependencies to metadata.rb (DONE)
* build several  attributes for arch and version download  (TODO)
* create templates (DONE)
* create files (DONE)
* constraint to redhat family (DONE)
* Do somethig cool with sysctl.conf  This is an horrible way, but has no dependencies. 
* Integrate with Opscode's database cookbook (WIP)
* use minitest, Luke! (DONE)
* build Readme.md and TODO.md  (DONE)
* Readme.md examples
* Try to build attributes for ASE Editions (Developer, Enterprise,..) (Wrong! use response_file.txt.erb template)
* try to run over others OS (TBD)
* add roles capabilities (TBD)

