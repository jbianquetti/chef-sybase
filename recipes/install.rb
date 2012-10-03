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
  home    "#{node['sybase']['homedir']}"
  comment "Sybase Adaptive Server"
  supports :manage_home => true
end

# create sybase group
group node['sybase']['group'] do 
  members  "#{node['sybase']['user']}"
end

# TODO:  Do somethig cool with sysctl.conf  maybe with Chef::File:Edit ! This is an horrible way !
execute "Raising shared memory" do 
 command "echo kernel.shmmax = #{ node['sybase']['shmmax'] } >> /etc/sysctl.conf && sysctl -p"
 not_if "grep kernel.shmmax /etc/sysctl.conf"
end

# Download Sybase installer
ark "sybase_installer" do
  url "#{node['sybase']['url']}"
  prefix_root "#{node['sybase']['homedir']}"
  prefix_home "#{node['sybase']['homedir']}"
  path  "#{node['sybase']['homedir']}"
  owner "#{node['sybase']['user']}"
  group "#{node['sybase']['group']}" 
  checksum "#{node['sybase']['checksum']}"
  action :put
end


# Templates to build ASE server
# Recommended setup is one install for user
# Copy this recipe  and modify line template "other_template.rs" do ....
template "server.rs" do
  source "server.rs.erb" 
  path    "#{node['sybase']['homedir']}/sybase_installer/server.rs" 
  mode   "644"
  action :create_if_missing
end

template "sqlloc.rs" do
  source "sqlloc.rs.erb"
  path   "#{node['sybase']['homedir']}/sybase_installer/sqlloc.rs" 
  mode   "644"
  action :create_if_missing
end

template "response_file.txt" do
  source "response_file.txt.erb"
  path   "#{node['sybase']['homedir']}/sybase_installer/response_file.txt" 
  mode   "644"
  action :create_if_missing
end

# Create directories for db devices  and logs
%w{var/lib/sybase var/log}.each do  |dir|
  directory "#{node['sybase']['homedir']}/#{dir}" do
    owner     "#{node['sybase']['user']}"
    group     "#{node['sybase']['group']}"
    action    :create
    recursive true 
  end 
end 


# fire up installer 
# May cause problems with several installations over same user's homedir. 
# Recommended setup is one install for user
# Copy this recipe  and add a first line: node['sybase']['user'] = "some_other_username" 
execute "installing sybase" do 
    cwd  "#{node['sybase']['homedir']}/sybase_installer" 
    command "./setup -is:javaconsole -silent -options #{node['sybase']['homedir']}/sybase_installer/response_file.txt  -W SybaseLicense.agreeToLicense=true"
    user      "#{node['sybase']['user']}"
    group     "#{node['sybase']['group']}"
    creates "#{ node['sybase']['homedir']}/SYBASE.sh"  
    not_if { node.attribute?('sybase_already_installed') }
end

template "srvbuild.sh" do
  source "srvbuild.sh.erb"
  path   "#{node['sybase']['homedir']}/srvbuild.sh" 
  mode   "755"
  action :create_if_missing
end

# Configuring ASE Server
execute "Configuring ASE Server" do
  cwd  "#{node['sybase']['homedir']}" 
  command "./srvbuild.sh"
  user      "#{node['sybase']['user']}"
  group     "#{node['sybase']['group']}"
  creates "#{ node['sybase']['homedir']}/ASE-15_0/install/RUN_#{node['sybase']['server']}"  
  not_if { node.attribute?('sybase_already_installed') }
end

# Set up complete? Possible hardcoded SYBASE DIR. Read from ENV
if File.exist? "#{ node['sybase']['homedir']}/ASE-15_0/install/RUN_#{node['sybase']['server']}" 
   node.set['sybase_already_installed'] = true
   node.save
end 



# Service building
# one script per user 
template "sybase-#{node['sybase']['server']}" do
	source "sybase.init.erb"
        path   "/etc/init.d/sybase-#{node['sybase']['server']}"
        mode    "755"
end

service "sybase-#{node['sybase']['server']}" do
  supports :status => false, :restart => false, :reload => false
  action [ :enable, :start ]
end



# TODO: Create dababase with LWRP


