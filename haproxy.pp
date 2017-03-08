node 'c2-r13-u27-n1.openstack.tld',
     'c2-r13-u27-n2.openstack.tld',
     'c2-r13-u27-n3.openstack.tld',
     'c2-r13-u27-n4.openstack.tld'{
  warning('These are the galera cluster nodes for misc infra!')
  class{'epel':} ->
  class{'selinux':
    mode => 'disabled',
    type => 'targeted',
  } ->
  package{[
    'iptables-services',
    'screen',
  ]:
    ensure => latest,
  }
  file{'/root/bin':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0770',
  }
  class{'haproxy': 
  global_options   => {
    'maxconn' => undef,
    'user'    => 'root',
    'group'   => 'root',
    'stats'   => [
      'socket /var/lib/haproxy/stats',
      'timeout 30s'
    ]
  },
  defaults_options => {
    'retries' => '5',
    'option'  => [
      'redispatch',
      'http-server-close',
      'logasap',
    ],
    'timeout' => [
      'http-request 7s',
      'connect 3s',
      'check 9s',
    ],
    'maxconn' => '15000',
  },
}
  warning('These are the HA Proxy cluster nodes for misc infra!')  
  include ::haproxy
  haproxy::listen { 'galera':
    collect_exported => false
	ipaddress        => $::10.13.1.18,10.13.1.20,10.13.1.22,10.13.1.24
    ports            => '8140',
  }	
  haproxy::balancermember { 'c2-r13-u31-n1':
    listening_service => 'galera',
	server_name       => 'c2-r13-u31-n1.openstack.tld',
    ipaddress         => '10.13.1.18',
    ports             => '8140',
	mode              => 'tcp',
    options           => 'check',
  }
  haproxy::balancermember { 'c2-r13-u31-n2':
    listening_service => 'galera',
	service_name      => 'c2-r13-u31-n2.openstack.tld',
	ipaddress         => '10.13.1.20',
	ports             => '8140',
	mode              => 'tcp',
	options           => 'check',
  }
}  
class { 'haproxy':
  global_options   => {
    'log'     => "${::ipaddress} local0",
    'chroot'  => '/var/lib/haproxy',
    'pidfile' => '/var/run/haproxy.pid',
    'maxconn' => '4000',
    'user'    => 'haproxy',
    'group'   => 'root',
    'daemon'  => 'galera',
    'stats'   => 'socket /var/lib/haproxy/stats',
  },
  defaults_options => {
    'log'     => 'global',
    'stats'   => 'enable',
    'option'  => [
      'redispatch',
    ],
    'retries' => '3',
    'timeout' => [
      'http-request 10s',
      'queue 1m',
      'connect 10s',
      'client 1m',
      'server 1m',
      'check 10s',
    ],
    'maxconn' => '8000',
  },
  haproxy::listen { 'galera':
  ipaddress => $::10.13.1.36,10.13.1.34,10.13.1.35,10.13.1.33,
  ports     => '18140',
  mode      => 'tcp',
  options   => {
    'option'  => [
      'tcplog',
    ],
    'balance' => 'roundrobin',
  },
}
   
