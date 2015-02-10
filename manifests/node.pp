class profile::node {
    include profile::apache

    class { 'nodejs':
        version     => latest,
        dev_package => true,
        manage_repo => false,
    }

    package { 'npm':
        ensure  => latest,
        require => Class[nodejs]
    }

    file { '/usr/bin/node':
        ensure  => link,
        require => Class[nodejs],
        target  => '/usr/bin/nodejs'
    }
}
