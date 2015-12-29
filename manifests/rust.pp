class profile::rust (
  $ensure  = 'present',
) {
  validate_re($ensure, '^(present|absent)$')

  class { '::rustlang':
    ensure => $ensure,
  }
}

