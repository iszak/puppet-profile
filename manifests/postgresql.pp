class profile::postgresql {
    class { 'postgresql::globals': }
    class { 'postgresql::client': }
    class { 'postgresql::server':
        require => Class['postgresql::globals']
    }

    class { 'postgresql::lib::devel':
        link_pg_config => false
    }

    # TODO: Remove
    file { '/usr/bin/pg_config':
        ensure  => link,
        require => Class['postgresql::lib::devel'],
        target  => '/usr/bin/pg_config.libpq-dev'
    }

    package { 'postgresql-server-dev-9.3':
        ensure  => latest,
        require => Class['postgresql::server']
    }
}
