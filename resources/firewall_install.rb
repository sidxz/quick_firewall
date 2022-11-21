# This resource would open a firewall port
unified_mode true

provides :firewall_install,
          os: 'linux'

action :install do
  case node['platform']
  when 'oracle', 'centos', 'fedora'
    package 'firewalld' do
      action :install
    end

    service 'firewalld' do
      action [ :enable, :start ]
    end

    firewall_open_service 'ssh' do
      service_name 'ssh'
      only_if "#{node['quick_firewall']['open_ssh']}"
      action :create
    end

  when 'ubuntu'
    package 'ufw' do
      action :install
    end

    execute 'enable-ufw' do
      command 'ufw --force enable && ufw default allow outgoing && ufw default deny incoming'
      only_if 'ufw status | grep inactive'
    end

    firewall_open_port '22' do
      port 22
      protocol 'tcp'
      only_if "#{node['quick_firewall']['open_ssh']}"
      action :create
    end
  end

end
