class profile::monitor::backend {
  class { '::graphite':
    gr_web_server      => 'apache',

    gr_django_pkg      => 'django',
    gr_django_ver      => '1.5',
    gr_django_provider => 'pip',
  }
}
