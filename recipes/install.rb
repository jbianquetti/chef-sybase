#
# Cookbook Name:: chef-sybase
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute


include_recipe "ark"

Chef::Log.info("watch out! SELINUX!!!!")

# install dependencies 
%w(libaio compat-libstdc++-33).each do |pkg|
    package pkg
end

# Create sybase user
user node['sybase']['user'] do 
  homedir [ node['sybase']['user']['homedir'] ] 
  comment "Sybase Adaptive Server"
  system true 
end

# create sybase group
group node['sybase']['group'] do 
  members [ node['sybase']['user'] ] 
end

# TODO:  Do somethig cool with sysctl.conf  maybe with Chef::File:Edit ! This is an horrible way !
execute "Raising shared memory" do 
 command "echo kernel.shmmax = #{ node['sybase']['user']['shmmax'] } >> /etc/sysctl.conf && sysctl -p"
 not_if "grep kernel.shmmax /etc/sysctl.conf"
end

# Download Sybase installer
ark "sybase_installer" do
  url "#{node['sybase']['url']}"
  path "#{node['sybase']['user']['homedir']}"
  owner "#{node['sybase']['user']}"
  group "#{node['sybase']['group']}" 
  checksum "#{node['sybase']['url']['checksum']}"
end


# Templates to build ASE server
# Recommended setup is one install for user
# Copy this recipe  and modify line template "other_template.rs" do ....
template "server.rs" do
  source "server.rs.erb" 
  path    "#{node['sybase']['user']['homedir']}/sybase_installer" 
  mode   "640"
  action :create_if_missing
end

template "sqlloc.rs" do
  source "sqlloc.rs.erb"
  path   "#{node['sybase']['user']['homedir']}/sybase_installer" 
  mode   "640"
  action :create_if_missing
end

template "response_file.txt" do
  source "response_file.txt.erb"
  path   "#{node['sybase']['user']['homedir']}/sybase_installer" 
  mode   "640"
  action :create_if_missing
end

# Create directories for db devices  and logs
%w{var/lib/sybase var/log}.each do  |dir|
  directory "#{node['sybase']['user']['homedir']}/#{dir}" do
    owner     node['sybase']['user']
    group     node['sybase']['group'] 
    action    :create
    recursive true 
  end 
end 


# fire up installer 
# May cause problems with several installations over same user's homedir. 
# Recommended setup is one install for user
# Copy this recipe  and add a first line: node['sybase']['user'] = "some_other_username" 
execute "installing sybase*" do 
    cwd  "#{node['sybase']['user']['homedir']}/sybase_installer" 
    command "./setup -console  -silent -file response_file.txt"
    owner     node['sybase']['user']
    group     node['sybase']['group'] 
    not_if { node.attribute?('sybase_already_installed') }
end


# Configuring ASE Server
# TODO: create a LWRP 
# ~/SYBASE.sh uses too much env keys for use with rubys' ENV, I prefer handling it with a bash resource
bash "Configuring ASE Server" do
  user "#{node['sybase']['user']}"
  code <<-EOH 
        set -e 
        source  ~/SYBASE.sh
        srvbuildres -r  [ [ node['sybase']['user']['homedir']"/sybase_installer/server.rs" ] 
        sqllocres -r  [ [ node['sybase']['user']['homedir']"/sybase_installer/sqlloc.rs" ]    
      EOH
  creates "#{ node['sybase']['user']['homedir']}/sybase_installer/install/RUN_#{node['sybase']['user']['server']}.sh"  
  not_if { node.attribute?('sybase_already_installed') }
end

# Set up complete? Possible hardcoded SYBASE DIR. Read from ENV
if File.exist? "#{ node['sybase']['user']['homedir']}/sybase_installer/install/RUN_#{node['sybase']['user']['server']}.sh" 
   node.set['sybase_already_installed'] = true
   node.save
end 



# Service building
# one script per user 
template "sybase-#{node['sybase']['user']['server']}" do
	source "sybase.init.erb"
        path   "/etc/init.d"
        mode    "755"
	variables(
	  :server => node['sybase']['user']['server']
	)
end

service "sybase-#{node['sybase']['user']}" do
  supports :status => false, :restart => false, :reload => false
  action [ :enable, :start ]
end



# TODO: Create dababase with LWRP


