default['sybase']['user'] = 'sybase' # default user 
default['sybase']['group'] = 'sybase' # default group 
default['sybase']['user']['homedir'] = '/opt/sybase'  # default $HOME
default['sybase']['user']['shmmax'] = '67108864' # 32MB is the default shared memory max size # Sybase needs at least 64MB
default['sybase']['user']['server'] = 'SYBASE' # Default ASE server name
default['sybase']['user']['server_port'] = '5000' # Default ASE server name
default['sybase']['sybase_already_installed'] = false  # By default, this is false
#default['sybase']['url'] = "http://vmsysbase.sadiel.es/distro/ase1503_linuxx86-64.tgz"  # INTERNAL URL to download sybase installer (version 15.0.3) (Only for deployment)
default['sybase']['url'] = "http://download.sybase.com/eval/1503/ase1503_linuxx86-64.tgz" # URL  to 15.0.3
default['sybase']['url']['checksum'] =  "273cda10eec9015491029347c1aaad24562b078766d968922707a3127309e0c8"  # sha256sum of sybase installer (version 15.0.3)
#default['sybase']['url'] = "http://download.sybase.com/eval/157/ase157_linuxx86-64.tgz" # Url for 15.7



# SA user 
default['sybase']['sa_pass'] = "" # password for SA, shared for every install,  default to null

# Localization settings (defaults to utf8)
default['sybase']['charset'] = "utf8" 
default['sybase']['sort_order'] = "bin_utf8" 
