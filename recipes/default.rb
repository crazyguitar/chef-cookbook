#
# Cookbook Name:: docker-registry
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'apt::default'
include_recipe 'poise-python::default'

file '/etc/apt/sources.list.d/docker.list' do
  content 'deb https://apt.dockerproject.org/repo ubuntu-trusty main'
  mode '0644'
end

package 'git'
package 'apt-transport-https' 
package 'ca-certificates'
package 'python-dev'
package 'python-pip'

execute 'Add the new GPG key' do
  command 'apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D'
end

execute 'Update the APT' do
  command 'apt-get update'
end

execute 'Verify that APT' do
  command 'apt-cache policy docker-engine'
end

package 'docker-engine'

git '/home/ubuntu/Portus' do
  repository 'https://github.com/SUSE/Portus'
  reference 'master'
  action :sync
end

python_package 'docker-compose'

execute 'Install Portus' do
  cwd '/home/ubuntu/Portus'
  command 'echo "Y" | ./compose-setup.sh -e 52.193.236.39'
  user 'root'
end
