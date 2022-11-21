# quick_firewall cookbook

This cookbook is intended to configure basic firewall settings that are used commonly.
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

For advanced firewall configuration, please have a look at the ![firewall](https://github.com/sous-chefs/firewall/) cookbook bu sous-chef.