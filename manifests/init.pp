# == Class: heartbeat
#
# Heartbeat configures a plain env.
#
# === Parameters
#
# [*authkey*]
#   Just a random string that is used for secure communication between cluster nodes.
# [*nodes*]
#   Array of the two heartbeat nodes.
# [*resources*]
#   Array of which each field is one resource line in the heartbeat config file haresources.
# [*udpport*]
#   Port for internal cluster communication.
#   Default is 694
# [*ucastIf*]
#   Interface on which unicast ip listens.
#   Default is eth0.
# [*autoFailback*]
#   Activate/deactivate auto takeover for resources.
#   Default is off.
#
# === Example
#
# Here are two nodes which balance/takeover tow virtual IPs:
#
#	class {'heartbeat':
#		authkey   => 'very5ecure',
#		nodes     => ['node1.example.domain', 'node2.example.domain'],
#		resources => ["node1.example.domain IPaddr2::10.0.1.1/8/eth0:vip1", "node2.example.domain IPaddr2::10.0.1.2/8/eth0:vip2"],
#		ucastIf   => 'eth0'
#	}
#
class heartbeat (
	$authkey      = 'secure123',
	$nodes        = '',
	$resources    = '',
	$udpport      = 694,
	$ucastIf      = 'eth0',
	$logfile      = '',
	$autoFailback = 'off'
){
	package { "heartbeat" : ensure => installed	}

	service {
		"heartbeat":
			ensure    => running,
			enable    => true,
			hasstatus => true,
			require   => [
				Package["heartbeat"],
				File['/etc/ha.d/haresources'],
				File['/etc/ha.d/ha.cf'],
				File['/etc/ha.d/authkeys']
			];
	}

	file {
		"/etc/ha.d/haresources":
		         notify  => Service["heartbeat"],
			 mode    => 0644,
			 owner   => root,
			 group   => root,
			 content => template("heartbeat/etc/ha.d/haresources.erb"),
			 require => Package["heartbeat"];
		"/etc/ha.d/ha.cf":
		         notify  => Service["heartbeat"],
			 mode    => 0644,
			 owner   => root,
			 group   => root,
			 content => template("heartbeat/etc/ha.d/ha.cf.erb"),
			 require => Package["heartbeat"];
		"/etc/ha.d/authkeys":
			 mode    => 0600,
			 owner   => root,
			 group   => root,
			 content => template("heartbeat/etc/ha.d/authkeys.erb"),
			 require => Package["heartbeat"];
	}
}
