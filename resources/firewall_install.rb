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

  when 'ubuntu'
    package 'ufw' do
      action :install
    end

    execute 'enable-ufw' do
      command 'ufw enable && ufw default allow outgoing && ufw default deny incoming'
      only_if 'ufw status | grep inactive'
    end
  end

end
