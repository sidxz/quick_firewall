# This resource would open a firewall port
unified_mode true

provides :firewalld_zone,
          os: 'linux'

property :name,
          String,
          description: 'Specify the name of the zone'

property :source,
          String,
          default: '',
          description: 'source network ip/range'

property :interface,
          String,
          default: '',
          description: 'Attach Interface to the zone'

action :create do
  case node['platform']
  when 'oracle', 'centos', 'fedora'

    # Check if firewall is up and running
    log 'firewall_unconfigured' do
      level        :fatal
      message      'Cannot open ports as the firewall service is not running'
      not_if       'systemctl status firewalld | grep "active (running)"'
    end

    cmd = "firewall-cmd --new-zone=#{new_resource.name} "
    check = 'firewall-cmd --get-zones '

    cmd.concat('--permanent ')
    cmd.concat('&& firewall-cmd --reload')
    check.concat("| grep -w #{new_resource.name}")

    execute "firewalld-create-zone-#{new_resource.name}" do
      command cmd
      not_if check
    end

    if new_resource.source != ''
      cmd = "firewall-cmd --zone=#{new_resource.name} --add-source=#{new_resource.source} "
      cmd.concat('--permanent ')
      cmd.concat('&& firewall-cmd --reload')

      check = "firewall-cmd --zone=#{new_resource.name} --list-all "
      check.concat("| grep -w #{new_resource.source}")

      execute "firewalld-add-source#{new_resource.source}-zone-#{new_resource.name}" do
        command cmd
        not_if check
      end

      if new_resource.interface != ''
        cmd = "firewall-cmd --zone=#{new_resource.name} --change-interface=#{new_resource.interface} "
        cmd.concat('--permanent ')
        cmd.concat('&& firewall-cmd --reload')
  
        check = "firewall-cmd --zone=#{new_resource.name} --list-interfaces "
        check.concat("| grep -w #{new_resource.interface}")
  
        execute "firewalld-add-interface#{new_resource.interface}-zone-#{new_resource.name}" do
          command cmd
          not_if check
        end
      end
    end

  when 'ubuntu'
    log 'zones_unavailable' do
      message 'Zones are not available in UFW'
      level :info
    end

  end
end
