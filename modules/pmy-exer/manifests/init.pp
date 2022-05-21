class pmy-exer{

	#install packages
	$installPack = [ 'vim-enhanced' , 'curl' , 'git' ]

	package { $installPack: ensure => 'installed', }

	#create user
	user { 'monitor':
		ensure => 'present',
		home => '/home/monitor',
		shell => '/bin/bash',
		managehome => true,
		before => Package[$installPack],
	}

	#create directory
	#file { '/home/monitor/scripts':
	#	ensure => 'directory',
	#	owner => 'monitor',
	#	group => 'root',
	#	mode => '0755',
	#	before => User['monitor'],
	#}

	$directories = [ '/home/monitor' , '/home/monitor/scripts' ]	
	file { $directories: 
		ensure => 'directory',
		owner => 'root',
		group => 'root',
		mode => '0750',
		before => User['monitor'],
	}

}
