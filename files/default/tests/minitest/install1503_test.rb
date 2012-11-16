require 'minitest/spec'

describe_recipe 'sybase::install1503' do

  # It's often convenient to load these includes in a separate
  # helper along with
  # your own helper methods, but here we just include them directly:
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources
  
  describe "packages" do
    it "install dependencies" do
      package("libaio").must_be_installed
      package("compat-libstdc++-33").must_be_installed
    end
  end

  describe "users and groups" do
    it "Create sybase user" do
        user(node['sybase']['user']).must_exist.with(:home, node['sybase']['homedir'])
        user(node['sybase']['user']).must_have(:comment, 'Sybase Adaptive Server')
    end


   it "create sybase group" do
     group(node['sybase']['group']).must_include(node['sybase']['user'])
   end
 end

 describe "Pre install tasks" do 
   it "Raising shared memory" do
     file('/etc/sysctl.conf').must_match '^kernel\.shmmax'
   end 

   it "Downloaded Sybase installer" do
     directory(node['sybase']['homedir']+'/sybase_installer').must_exist.with(:owner, node['sybase']['user'])
   end

   it "has Templates to build ASE server" do
     file(node['sybase']['homedir']+'/sybase_installer/server.rs').must_exist
     file(node['sybase']['homedir']+'/sybase_installer/sqlloc.rs').must_exist
     file(node['sybase']['homedir']+'/sybase_installer/response_file.txt').must_exist
   end

   it "Create directories for db devices  and logs" do
     directory(node['sybase']['homedir']+'/var/log').must_exist.with(:owner, node['sybase']['user'])
     directory(node['sybase']['homedir']+'/var/lib/sybase').must_exist.with(:owner, node['sybase']['user'])
   end   

   it "can installing sybase" do 
    file(node['sybase']['homedir']+'/sybase_installer/setup').must_exist
   end
   
 end

 describe "Check out if installer job it's done" do 
   it "has installed sybase" do
    file(node['sybase']['homedir']+'/SYBASE.sh').must_exist
   end

   it "svrbuild.sh run ok" do
    file(node['sybase']['homedir']+'/srvbuild.sh').must_exist
    file(node['sybase']['homedir']+'/ASE-15_0/install/RUN_'+node['sybase']['server']).must_exist
   end 
 end
 
 describe "service" do 
   it "Runs sybase dataserver" do
    service('sybase-'+node['sybase']['server']).must_be_running
   end
 end
  


 end
