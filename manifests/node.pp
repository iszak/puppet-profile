class profile::node {
    include ::profile::apache

    class { 'nodejs':
        nodejs_package_ensure     => latest,
        nodejs_dev_package_ensure => latest,
        npm_package_ensure        => latest,
        manage_package_repo       => false,
    }

    file { '/usr/bin/node':
        ensure  => link,
        require => Class[nodejs],
        target  => '/usr/bin/nodejs'
    }
}
