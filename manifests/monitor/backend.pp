class profile::monitor::backend {
  class { '::graphite':
    gr_storage_schemas => [
      {
        name       => 'default',
        pattern    => '.*',
        retentions => '1s:1d,1m:1m,5m:1y'
      }
    ],

    gr_web_server      => 'apache',

    gr_django_pkg      => 'django',
    gr_django_ver      => '1.5',
    gr_django_provider => 'pip',
  }
}
