class apache {
  require apache::config
  require homebrew

  # Bring default plist under our control - taken from Mountain Lion 10.8.2

  file { '/System/Library/LaunchDaemons/org.apache.httpd.plist':
    content => template('apache/org.apache.httpd.plist.erb'),
    group   => 'wheel',
    notify  => Service['org.apache.httpd'],
    owner   => 'root'
  }

  # Add all the directories and files Apache is expecting
  # Most of these should already exist on Mountain Lion

  file { [
    $apache::config::configdir,
    $apache::config::logdir,
    $apache::config::sitesdir,
    $apache::config::portdir,
  ]:
    ensure => directory,
    owner  => root,
    group  => wheel,
  }

  file { $apache::config::configfile:
    content => template('apache/config/apache/httpd.conf.erb'),
    notify  => Service['org.apache.httpd'],
    owner   => root,
    group   => wheel
  }

  service { "org.apache.httpd":
    ensure => running,
    require => File[$apache::config::configfile]
  }

}
