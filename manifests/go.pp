class profile::go (
  $ensure => 'present',
) {
  validate_re($ensure, '^(present|absent)$')

  class { '::golang':
    ensure => $ensure,
  }
}
