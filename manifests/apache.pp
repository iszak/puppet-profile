class profile::apache {
    class { '::apache':
        mpm_module       => 'prefork',
        default_mods     => false,
        default_vhost    => false,
        server_tokens    => 'Prod',
        server_signature => 'Off',
    }

    class { 'apache::mod::dir': }
    class { 'apache::mod::mime': }
    class { 'apache::mod::deflate': }
    class { 'apache::mod::ssl': }
    class { 'apache::mod::proxy': }
    class { 'apache::mod::proxy_http': }
}
