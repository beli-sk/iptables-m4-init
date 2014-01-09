iptables-m4-init
================

Simple init script for loading iptables rules with M4 macro processing.

Requirements
------------

 - GNU/Linux distribution supporting LSB Init Scripts (tested on Debian Wheezy and Ubuntu Precise, could also work on RedHat-based distributions)
 - [GNU M4](http://www.gnu.org/software/m4/) (available as a package in all major GNU/Linux distributions, already installed in most cases)

Installation
------------

    cp -i default/iptables /etc/default/
    cp -i init.d/iptables /etc/init.d/
    mkdir /etc/iptables
    cp -i iptables/* /etc/iptables/
