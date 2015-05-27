class profile::base {
    include ::git
    include ::ntp

    class { '::apt':
        always_apt_update => true
    }

    include ::apt::unattended_upgrades


    class { '::ssh::server':
        storeconfigs_enabled => false,
        options => {
            'LoginGraceTime'                  => 120,
            'StrictModes'                     => 'yes',
            'PrintMotd'                       => 'no',
            'UsePam'                          => 'no',
            'PermitRootLogin'                 => 'no',
            'AllowTcpForwarding'              => 'no',
            'X11Forwarding'                   => 'no',
            'PasswordAuthentication'          => 'no',
            'ChallengeResponseAuthentication' => 'no',
        }
    }
}
