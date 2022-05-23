class pmy-exer{

	#install packages
	$installPack = [ 'vim-enhanced' , 'curl' , 'git' ]

	package { $installPack: 
		ensure => 'installed',
		before => User['monitor'],
	}

	#create user
	user { 'monitor':
		ensure => 'present',
		home => '/home/monitor',
		shell => '/bin/bash',
		managehome => true,
		require => Package[$installPack],
	}

	#create directory
	#file { '/home/monitor/scripts':
	#	ensure => 'directory',
	#	owner => 'monitor',
	#	group => 'root',
	#	mode => '0755',
	#	require => User['monitor'],
	#}

	$directories = [ '/home/monitor' , '/home/monitor/scripts' ]	
	file { $directories: 
		ensure => 'directory',
		owner => 'root',
		group => 'root',
		mode => '0750',
		require => User['monitor'],
	}

	#download memory check from git
	exec { 'get-from-git':
		cwd => '/tmp',
		command => '/bin/wget https://raw.githubusercontent.com/jmvillasencio/memory_check/master/memory_check.sh -O /home/monitor/scripts/memory_check.sh',
		require => File[$directories],
	}

	#create directory
	file { '/home/monitor/src':
		ensure => 'directory',
		owner => 'root',
		group => 'root',
		mode => '0755',
		require => Exec['get-from-git'],
	}

	#create soft link
	exec { 'softlink':
		cwd => '/tmp/',
		command => '/bin/ln -sf /home/monitor/scripts/memory_check.sh /home/monitor/src/my_memory_check',
		require => File['/home/monitor/src'],		
	} 

	#create crontab
	cron { 'my-memory-check':
	ensure => present,
	command => "/home/monitor/src_my_memory_check.sh -c 80 -w 60 -e taffertywilliams@gmail.com",
	user => 'root',
	minute => '*/10',
	require => Exec['softlink'],
	}

	#bonus hostname
	exec { 'hostname':
	cwd => '/tmp/',
	command => '/bin/hostname bpx.server.local',
	require => Cron['my-memory-check'],
	}

	#bonus timezone-manila
	exec { 'timezone':
	cwd => '/tmp/',
	command => '/bin/timedatectl set-timezone Asia/Manila',
	require => Exec['hostname'],
	}

}


