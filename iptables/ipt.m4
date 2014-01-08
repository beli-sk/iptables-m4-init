m4_divert(`-1')
#
# This file is part of iptables-m4-init.
#
# iptables-m4-init is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# iptables-m4-init is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with iptables-m4-init.  If not, see <http://www.gnu.org/licenses/>.
#
# -------------------------------------------------------------------------
#
# iptables example rules for home router/firewall
#
m4_divert`'m4_dnl
m4_include(`include.m4')m4_dnl
m4_define(uplink_if, eth1)m4_dnl
m4_define(lan_if, eth0)m4_dnl
m4_define(lan_net, 192.168.9.0/24)m4_dnl
m4_define(lan_ip, 192.168.9.1)m4_dnl
m4_define(lan_server1, 192.168.9.15)m4_dnl
m4_define(ext_dns, 8.8.8.8)m4_dnl
*filter
:INPUT DROP
:FORWARD DROP
:OUTPUT ACCEPT
:ctrack -
:in-srv -
:out-fwd-lan -

-A INPUT -i lo -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i uplink_if -p ipv6 -j ACCEPT
-A INPUT -j ctrack
# services from internal network
-A INPUT -m conntrack --ctstate NEW -s lan_net -i lan_if -j in-srv
# reject firewalled ports
-A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
-A INPUT -p tcp -j REJECT --reject-with tcp-rst
-A INPUT -j REJECT --reject-with icmp-proto-unreachable

-A FORWARD -j ctrack
-A FORWARD -i lan_if -s lan_net -o uplink_if -j ACCEPT
-A FORWARD -i uplink_if -o lan_if -j out-fwd-lan
-A FORWARD -j REJECT --reject-with icmp-host-unreach

# general connection tracking rules
-A ctrack -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A ctrack -m conntrack --ctstate INVALID -j DROP

# allowed services from internal network
-A in-srv -p tcp -m tcp --dport ssh -j ACCEPT

# forwarding from outside into LAN
-A out-fwd-lan -d lan_server1 -p tcp -m tcp --dport https -j ACCEPT
COMMIT
*nat
:PREROUTING ACCEPT
:INPUT ACCEPT
:OUTPUT ACCEPT
:POSTROUTING ACCEPT
reptcpudp(`-A PREROUTING -i lan_if -p xxp -m xxp --dport domain -j DNAT --to-destination ext_dns')
-A PREROUTING -i uplink_if -p tcp -m tcp --dport https -j DNAT --to-destination lan_server1
-A POSTROUTING -s lan_net -o uplink_if -j MASQUERADE
COMMIT
