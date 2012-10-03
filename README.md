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

TODO
==========
 
* build default attributes (DONE)
* add recipe's dependencies to metadata.rb (DONE)
* build several  attributes for arch and version download 
* create templates (DONE)
* create files (DONE)
* constraint to redhat family (DONE)
* Do somethig cool with sysctl.conf  This is an horrible way, but has no dependencies.
* Integrate with Opscode's database cookbook
* use minitest, Luke!
* build Readme.md and TODO.md 
* Readme.md examples
* Try to build attributes for ASE Editions (Developer, Enterprise,..) (Wrong! use response_file.txt.erb template)
* try to run over others OS
* add roles capabilities


