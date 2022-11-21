#
# Cookbook:: quick_firewall
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.

firewall_install 'default' do
  action :install
end

# Example
# firewall_open_service 'https' do
#   service_name 'https'
#   action :create
# end

firewall_open_port '80' do
  port 80
  protocol 'tcp'
  action :create
end
