class profile::rust (
  $ensure  = 'present',
  $version = 'stable',
) {
  validate_re($ensure, '^(present|absent)$')
  validate_re($version, '^(stable|nightly|0\.[0-9]+)$')

  class { '::rustlang':
    ensure       => $ensure,
    package_name => "${package_name}-${version}",
  }
}

