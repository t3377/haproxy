node 'c2-r13-u31-n1.openstack.tld',
     'c2-r13-u31-n2.openstack.tld',
	   'c2-r13-u31-n3.openstack.tld',
	   'c2-r13-u31-n4.openstack.tld'{
  warning('These are the HA Proxy cluster nodes for misc infra!')  
  include ::haproxy
  haproxy::listen { '':
    collect_exported  => false
	ipaddress           => $::10.13.1.18,10.3.1.20,10.13.1.22,10.13.1.24
    ports             => '8140',
    mode              => 'tcp',
  }	
  haproxy::balancermember { 'c2-r13-u31-n1':
    listening_service => '
  	server_name       => 'c2-r13-u31-n1.openstack.tld',
    ipaddress         => '10.13.1.18',
    ports             => '8140',
	  mode              => 'tcp',
    options           => 'check',
  }
  haproxy::balancermember { 'c2-r13-u31-n2':
  listening_service => '
	service_name      => 'c2-r13-u31-n2.openstack.tld',
	ipaddress         => '10.13.1.20',
	ports             => '8140',
	mode              => 'tcp',
	options           => 'check',
  }
}  
class { 'haproxy':
  global_options  
   
