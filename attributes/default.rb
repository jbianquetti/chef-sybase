default['sybase']['user'] = "sybase" # default user 
default['sybase']['group'] = "sybase" # default group 
default['sybase']['homedir'] = "/home/sybase"  # default $HOME
default['sybase']['shmmax'] = "67108864" # 32MB is the default shared memory max size # Sybase needs at least 64MB
default['sybase']['server'] = "SYBASE" # Default ASE server name
default['sybase']['server_port'] = "5000" # Default ASE server name
default['sybase']['sybase_already_installed'] = false  # By default, this is false
default['sybase']['url'] = "http://download.sybase.com/eval/1503/ase1503_linuxx86-64.tgz" # URL  to 15.0.3
default['sybase']['checksum'] =  "b5eef9fa0b634082f4c3465ec2683bc08c44f804ab94087653d95eeccd7aaf22"  # sha256sum of sybase installer (version 15.0.3)

#  ASE 15.7 (x86-64) 
#default['sybase']['url'] = "http://download.sybase.com/eval/157/ase157_linuxx86-64.tgz" # Url for 15.7
#default['sybase']['cheksum'] = "d166ce65af9b27aa3ce219c81f177f0ad2171404ef705fb3f4bc5fb98c53572c"



# SA user 
default['sybase']['sa_pass'] = "" # password for SA, shared for every install,  default to null. Change it NOW

# Localization settings (defaults to utf8)
default['sybase']['charset'] = "utf8" 
default['sybase']['sort_order'] = "bin_utf8" 
