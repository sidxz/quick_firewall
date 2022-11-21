# This resource would open a firewall port
unified_mode true

provides :firewall_open_service,
          os: 'linux'

property :service_name,
          String,
          description: 'Specify the service to open'

property :comment,
          String,
          default: '',
          description: 'Comment to add on UFW'

property :allow_from_ip,
          String,
          default: '',
          description: 'UFW allow from IP or IP range'

property :allow_from_zone,
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

    cmd = "firewall-cmd --add-service=#{new_resource.service_name} "
    check = 'firewall-cmd --list-services '

    if new_resource.allow_from_zone != ''
      cmd.concat("--zone=#{new_resource.allow_from_zone} ")
      check.concat("--zone=#{new_resource.allow_from_zone} ")
    end

    cmd.concat('--permanent ')
    cmd.concat('&& firewall-cmd --reload')
    check.concat("| grep -w #{new_resource.service_name}")

    execute "firewalld-open-#{new_resource.name}" do
      command cmd
      not_if check
    end

  when 'ubuntu'
    log 'message' do
      message 'A message add to the log.'
      level :info
    end

  end
end
