#
# Cookbook:: quick_firewall
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.


# Install ufw/firewalld and keep ssh open by default
# To change this behavior, set 'open_ssh' to false in attributes

firewall_install 'default' do
  action :install
end

# If set to true in attributes, open ports for commonly used services
# default is set to false
if node['quick_firewall']['open_http'] do
  firewall_open_port '80' do
    port 80
    protocol 'tcp'
    action :create
  end
end

if node['quick_firewall']['open_https'] do
  firewall_open_service 'https' do
    service_name 'https'
    ufw_port_track '443'
    action :create
  end
end
