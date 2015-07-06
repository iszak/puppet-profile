class profile::php {
    include ::profile::apache

    class { 'apache::mod::php': }
}
