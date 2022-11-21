# This resource would open a firewall port
unified_mode true

provides :firewall_open_port,
          os: 'linux'

property :port,
          Integer,
          description: 'Specify the port to open'

property :protocol,
          String,
          description: 'Specify the protocol to open'

property :comment,
          String,
          default: '',
          description: 'Comment to add on UFW'

property :source,
          String,
          default: '',
          description: 'UFW allow from IP or IP range'

property :zone,
          String,
          default: '',
          description: 'Firewalld allow from specific zone. The Zone must exist'

action :create do
  case node['platform']
  when 'oracle', 'centos', 'fedora'

    # Check if firewall is up and running
    log 'firewall_unconfigured' do
      level        :fatal
      message      'Cannot open ports as the firewall service is not running'
      not_if       'systemctl status firewalld | grep "active (running)"'
    end

    cmd = "firewall-cmd --add-port=#{new_resource.port}/#{new_resource.protocol} "
    check = 'firewall-cmd --list-ports '

    if new_resource.zone != ''
      cmd.concat("--zone=#{new_resource.zone} ")
      check.concat("--zone=#{new_resource.zone} ")
    end

    cmd.concat('--permanent ')
    cmd.concat('&& firewall-cmd --reload')
    check.concat("| grep -w #{new_resource.port}/#{new_resource.protocol}")

    execute "firewalld-open-#{new_resource.name}" do
      command cmd
      only_if 'systemctl status firewalld | grep "active (running)"'
      not_if check
    end

  when 'ubuntu'
    # Check if firewall is up and running
    log 'firewall_unconfigured' do
      level        :fatal
      message      'Cannot open ports as the firewall service is not running'
      not_if       'ufw status | grep -w "active"'
    end

    cmd = 'ufw allow '
    check = 'ufw status '

    if new_resource.source != ''
      cmd.concat("from #{new_resource.source} ")
      check.concat("| grep -w '#{new_resource.source}' ")
    end

    cmd.concat("proto #{new_resource.protocol} to any port #{new_resource.port} ")
    check.concat("| grep -w '#{new_resource.port}/#{new_resource.protocol}' ")
    check.concat("grep -w 'ALLOW'")

    execute "ufw-open-#{new_resource.name}" do
      command cmd
      not_if check
    end

  end
end
