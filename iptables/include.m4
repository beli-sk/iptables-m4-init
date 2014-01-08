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
# reptcpudp(line)
#   repeat the line two times and changes string 'xxp' to 'tcp' in the first
#   line and to 'udp' in the second line.
m4_define(`reptcpudp', `m4_foreach(`xxp', (tcp, udp), `$1
')m4_dnl')m4_dnl
#
# m4_foreach(x, (item_1, item_2, ..., item_n), stmt)
#   parenthesized list, simple version
m4_define(`m4_foreach', `m4_pushdef(`$1')_foreach($@)m4_popdef(`$1')')
m4_define(`_arg1', `$1')
m4_define(`_foreach', `m4_ifelse(`$2', `()', `',
  `m4_define(`$1', _arg1$2)$3`'$0(`$1', (m4_shift$2), `$3')')')
m4_divert`'m4_dnl
