# quick_firewall cookbook

This cookbook is intended to configure basic firewall settings that are commonly used.
The modules make use of firewalld or ufw to set the rules.

PLEASE NOTE - The resource/providers in this cookbook are under development.

## Requirements

- Chef Infra Client 15.5+

```
depends 'quick_firewall'
```


### Supported firewalls and platforms
- UFW - Ubuntu, Debian
- FirewallD - Red Hat & CentOS >= 7.0

Tested on:

- Ubuntu 22.04 with ufw
- CentOS 7 with firewalld
- CentOS 8 with firewalld
- Oracle 9 with firewalld

## Resources

This cookbook comes with four resources:
- firewall_install
- firewall_open_port
- firewall_open_service
- firewall_zone


## Attributes

- `default['quick_firewall']['open_ssh'] = true`, set true to open port 22 for SSH when the default recipe runs


## Advanced Firewall
This cookbook takes the path where it relies more on the existing cli firewall tools `firewall-cmd` and `ufw` so that latest os versions can be supported out of the box compromising on granular controls but usefull enough for most scenarios.

For advanced firewall configuration, please have a look at the [firewall](https://github.com/sous-chefs/firewall/) cookbook by sous-chef.

## Usage
### Installation
To install and enable the firewall use the `firewall_install` resource.
```
firewall_install 'default' do
  action :install
end
```
This would keep the ssh port 22 open as an default action.
To preven this set 
`default['quick_firewall']['open_ssh'] = false`

### Oppening a port
The most basic way to open port 80 would be
```
firewall_open_port '80' do
    port 80
    protocol 'tcp'
    action :create
  end
```

Resource Definition:
```
firewall_open_port  'name' do
  port                Integer
  protocol            String
  source              String
  zone                TrueClass, FalseClass
  action              Symbol
end
```
where
* __port__ is the port that is required to be open
* __protocol__ is the protocol that the port uses, generally, tcp or udp
* __source__ An IP or a subnet from where the request will be allowed. Debian family only will be ignored in RHEL.
* __zone__ The firewall zone to use. Note RHEL Family only, will be ignored in Debian

### Oppening a service
Thoug we recommend to use the `firewall_open_port` resource, services can be oppened by this resource.
Example to open https.
```
firewall_open_service 'https' do
    service_name 'https'
    ufw_port_track '443'
    action :create
  end
```
Resource Definition:
```
firewall_open_service  'name' do
  service_name        String
  zone                String
  action              Symbol
end
```
where
* __service_name__ is the service that is required to be open. Example ssh, https, ldap etc
* __ufw_port_track__ (Debian ONLY) Ignored in RHEL, is the port of the corresponding service. 22 for SSH etc.
* __zone__ The firewall zone to use. Note RHEL Family only, will be ignored in Debian

### Creating a firewalld zone
This resource will create a firewall zone in the RedHat Family.
Example 1
```
firewall_zone 'xyz-private' do
    source '10.10.10.0/24'
    action :create
  end
```
Example 2
```
firewall_zone 'xyz-private' do
    interface 'eth-2'
    action :create
  end
```
Resource Definition:
```
firewall_zone  'name' do
  name          String
  source        String
  interface     String
  action        Symbol
end
```
where
* __name__ is the name of the zone to create
* __source__ is the source ip or network
* __interface__ if required, create the zone for a specific interfce.