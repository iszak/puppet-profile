class profile::postgresql {
  class { 'postgresql::server':
    encoding => 'UTF-8',
    locale   => 'en_US.UTF-8',
  }
  class { 'postgresql::client': }

  class { 'postgresql::lib::devel':
      link_pg_config => true
  }

  package { 'postgresql-server-dev-9.3':
      ensure  => latest,
      require => Class['postgresql::server']
  }
}
