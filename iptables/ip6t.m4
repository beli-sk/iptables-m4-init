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
# ip6tables example rules for home router/firewall
#
m4_divert`'m4_dnl
m4_include(`include.m4')m4_dnl
m4_define(uplink_if, eth1)m4_dnl
m4_define(lan_if, eth0)m4_dnl
m4_define(lan_net, fd49:fae1:f976::/64)m4_dnl
m4_define(lan_ip, fd49:fae1:f976::1/64)m4_dnl
*filter
:INPUT DROP
:FORWARD DROP
:OUTPUT ACCEPT
:ctrack -
:srv -
:in-srv -

-A INPUT -i lo -j ACCEPT
-A INPUT -p icmpv6 -j ACCEPT
-A INPUT -j ctrack
-A INPUT -p udp       -m conntrack --ctstate NEW -i uplink_if -j srv
-A INPUT -p tcp --syn -m conntrack --ctstate NEW -i uplink_if -j srv
-A INPUT -m conntrack --ctstate NEW -s lan_net -i lan_if -j in-srv
# reject firewalled ports
-A INPUT -p udp -j REJECT --reject-with icmp6-port-unreachable
-A INPUT -p tcp -j REJECT --reject-with tcp-reset

-A FORWARD -j ctrack
-A FORWARD -i lan_if -s lan_net -o uplink_if -j ACCEPT

-A ctrack -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A ctrack -m conntrack --ctstate INVALID -j DROP

-A in-srv -j srv

-A srv -p tcp -m tcp --dport ssh -j ACCEPT
COMMIT
