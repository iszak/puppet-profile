class profile::base {
    include ::git
    include ::ntp

    class { '::apt':
        always_apt_update => true
    }

    include ::apt::unattended_upgrades


    class { '::ssh':
        server_options => {
            'AllowTcpForwarding'     => 'no',
            'X11Forwarding'          => 'no',
            'PasswordAuthentication' => 'no',
        }
    }
}
