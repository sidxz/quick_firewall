# Quick Firewall Chef Cookbook

This cookbook is intended to configure basic firewall settings that are commonly used.

The modules make use of firewalld or ufw to set the rules.

This cookbook is not intended to provide complete OS Firewall wrapping via resources, but instead provides an easy way to add or remove simple rules. It is currently mainly used for host-based firewalls in Debian and RHEL Family.


## Requirements

- Chef Infra Client 16.0+

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
- `default['quick_firewall']['open_http'] = false`, set true to open port 80 for http when the default recipe runs
- `default['quick_firewall']['open_https'] = false`, set true to open port 443 for https when the default recipe runs

## Usage
### Installation
To install and enable the firewall use the `firewall_install` resource.
```
firewall_install 'default' do
  action :install
end
```
This would keep the ssh port 22 open as a default action.
To prevent this set 
`default['quick_firewall']['open_ssh'] = false`

### Opening a port
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

### Opening a service
Though we recommend to use the `firewall_open_port` resource, services can be opened by this resource.
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
* __service_name__ is the service that is required to be open. Examples ssh, https, ldap etc
* __ufw_port_track__ (Debian ONLY) Ignored in RHEL, is the port of the corresponding service. 22 for SSH etc.
* __zone__ The firewall zone to use. Note RHEL Family only, will be ignored in Debian

### Creating a firewalld zone
This resource will create a firewall zone in the RedHat Family.
Example 1
```
firewalld_zone 'xyz-private' do
    source '10.10.10.0/24'
    action :create
  end
```
Example 2
```
firewalld_zone 'xyz-private' do
    interface 'eth-2'
    action :create
  end
```
Resource Definition:
```
firewalld_zone  'name' do
  name          String
  source        String
  interface     String
  action        Symbol
end
```
where
* __name__ is the name of the zone to create
* __source__ is the source IP or network
* __interface__ if required, create the zone for a specific interface.


## Advanced Firewall
This cookbook takes the path where it relies more on the existing CLI firewall tools `firewall-cmd` and `ufw` so that it can be adapted rapidly with the latest OS releases though compromising on granular controls but useful enough for most basic scenarios.

For an advanced firewall configuration, please have a look at the [firewall](https://github.com/sous-chefs/firewall/) cookbook by sous-chef.

## License
The cookbook comes as is without any warranty.
