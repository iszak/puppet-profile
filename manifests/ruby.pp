class profile::ruby {
    include ::profile::apache

    class { 'apache::mod::passenger':
        require => [
            Class['ruby'],
            Apt::Source['passenger']
        ]
    }


    class { '::ruby':
        version        => latest,
        gems_version   => latest,
        latest_release => true,
    }

    class { 'ruby::dev':
        ensure => latest
    }


    apt::source { 'passenger':
        location          => 'https://oss-binaries.phusionpassenger.com/apt/passenger',
        repos             => 'main',
        required_packages => 'apt-transport-https ca-certificates',
        key               => '561F9B9CAC40B2F7',
        key_server        => 'keyserver.ubuntu.com',
        include_src       => false
    }

    package { 'passenger-dev':
        ensure  => latest,
        require => Apt::Source[passenger]
    }
}
