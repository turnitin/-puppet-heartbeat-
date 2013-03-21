# heartbeat module

This module manages heartbeat service. It uses plain heartbeat and uses unicast instead of broadcast, because that makes less problems in virtual environments.

# Tested on

RHEL/CentOS 6+

# Parameters

The descriptions are short and their are more variables to tweak your heartbeat if needed.

<table>
  <tr>
  	<th>Parameter</th><th>Default</th><th>Description</th>
  </tr>
  <tr>
    <td>authkey</td><td>secure123</td><td>Just a random string that is used for secure communication between cluster nodes.</td>
  </tr>
  <tr>
    <td>nodes</td><td>is empty</td><td>Array of the two heartbeat nodes.</td>
  </tr>
  <tr>
    <td>resources</td><td>is empty</td><td>Array of which each field is one resource line in the heartbeat config file haresources.</td>
  </tr>
  <tr>
    <td>udpport</td><td>694</td><td>Port for internal cluster communication.</td>
  </tr>
  <tr>
    <td>ucastIf</td><td>eth0</td><td>Interface on which unicast ip listens.</td>
  </tr>
  <tr>
    <td>autoFailback</td><td>off</td><td>Activate/deactivate auto takeover for resources.</td>
  </tr>
</table>

# Sample usage:

### Here are two nodes which balance/takeover tow virtual IPs:
<pre>
node "node01.example.domain" {
	class {'heartbeat':
        authkey   => 'very5ecure',
        nodes     => ['node1.example.domain', 'node2.example.domain'],
        resources => ["node1.example.domain IPaddr2::10.0.1.1/8/eth0:vip1", "node2.example.domain IPaddr2::10.0.1.2/8/eth0:vip2"],
        ucastIf   => 'eth0'
    }
}

node "node02.example.domain" {
	class {'heartbeat':
        authkey   => 'very5ecure',
        nodes     => ['node1.example.domain', 'node2.example.domain'],
        resources => ["node1.example.domain IPaddr2::10.0.1.1/8/eth0:vip1", "node2.example.domain IPaddr2::10.0.1.2/8/eth0:vip2"],
        ucastIf   => 'eth0'
    }
}
</pre>
