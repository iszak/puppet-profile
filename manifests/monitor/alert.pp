class profile::monitor::alert(
  $version                             = '1.3.0',
  $init_path                           = '/etc/init.d/seyren',

  $user                                = 'root',
  $group                               = 'root',

  $java_bin                            = '/usr/bin/java',

  $graphs_enable                       = true,

  $seyren_path                         = '/opt/seyren',
  $seyren_url                          = 'http://localhost:8080/seyren',
  $seyren_log_path                     = '/opt/seyren/log/',
  $seyren_log_file_level               = 'info',
  $seyren_threads                      = 8,

  $mongo_url                           = 'mongodb://localhost:27017/seyren',

  $graphite_url,
  $graphite_refresh                    = 60000,
  $graphite_username                   = '',
  $graphite_password                   = '',
  $graphite_keystore                   = '',
  $graphite_keystore_password          = '',
  $graphite_truststore                 = '',
  $graphite_connection_request_timeout = 0,
  $graphite_connect_timeout            = 0,
  $graphite_socket_timeout             = 0,

  $graphite_carbon_pickle_enable       = false,
  $graphite_carbon_pickle_port         = 2004,

  $smtp_host                           = 'localhost',
  $smtp_port                           = 25,
  $smtp_from                           = 'alert@seyren',
  $smtp_username                       = '',
  $smtp_password                       = '',
  $smtp_protocol                       = 'smtp',

  $http_notification_url               = '',

  $flowdock_external_username          = 'Seyren',
  $flowdock_tags                       = '',
  $flowdock_emojis                     = '',

  $hipchat_authtoken                   = '',
  $hipchat_username                    = 'Seyren Alert',

  $hubot_url                           = '',

  $irccat_host                         = 'localhost',
  $irccat_port                         = 12345,

  $pushover_app_api_token              = '',
) {
  validate_re($version, '^\d+\.\d+\.\d+$')
  validate_absolute_path($seyren_path)

  validate_bool($graphs_enable)

  validate_string($seyren_url)
  validate_absolute_path($seyren_log_path)
  validate_re($seyren_log_file_level, '^(trace|debug|info|warn|error)$')
  validate_integer($seyren_threads)

  validate_string($mongo_url)

  validate_string($graphite_url)
  validate_integer($graphite_refresh)
  validate_string($graphite_username)
  validate_string($graphite_password)
  validate_string($graphite_keystore)
  validate_string($graphite_keystore_password)
  validate_string($graphite_truststore)
  validate_integer($graphite_connection_request_timeout)
  validate_integer($graphite_connect_timeout)
  validate_integer($graphite_socket_timeout)

  validate_bool($graphite_carbon_pickle_enable)
  validate_integer($graphite_carbon_pickle_port)


  validate_string($smtp_host)
  validate_integer($smtp_port)
  validate_string($smtp_username)
  validate_string($smtp_password)
  validate_string($smtp_protocol)

  validate_string($http_notification_url)

  validate_string($flowdock_external_username)
  validate_string($flowdock_tags)
  validate_string($flowdock_emojis)

  validate_string($hipchat_authtoken)
  validate_string($hipchat_username)

  validate_string($hubot_url)

  validate_integer($irccat_port)

  validate_string($pushover_app_api_token)

  case $::osfamily {
    'debian': {

    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }

  class {'::mongodb::server':
    smallfiles => true
  }

  class { '::java':
    distribution => 'jre',
  }

  $filename = "seyren-${version}.jar"
  $download_url = "https://github.com/scobal/seyren/releases/download/${version}/${filename}"

  file { [
    $seyren_path,
    $seyren_log_path
  ]:
    ensure  => directory,
    recurse => true
  }

  exec { 'wget seyren':
    require => File[$seyren_path],
    command => "/usr/bin/wget ${download_url} --quiet --output-document=${seyren_path}/${filename}"
    unless  => "/usr/bin/test -f ${seyren_path}/${filename}"
  }


  file { "${seyren_path}/${filename}":
    require => Exec['wget seyren'],
    owner   => $user,
    group   => $group,
  }

  file { $init_path:
    mode    => 0754,
    owner   => 'root',
    group   => 'root',
    content => template('profile/monitor/alert/initd.erb'),
  }

  package { 'daemon':
    ensure => present
  }

  service { 'seyren':
    ensure  => running,
    require => [
      Package['daemon'],
      File["${seyren_path}/${filename}"],
      File[$init_path],
    ],
  }
}