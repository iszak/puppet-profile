class profile::monitor::agent(
  $apache = true,
  $disk = true,
  $entropy = true,
  $load = true,
  $memory = true,
  $network = true,
  $postgresql = true,
  $swap = true,
  $user = true,
) {
  validate_bool($apache)
  validate_bool($disk)
  validate_bool($entropy)
  validate_bool($load)
  validate_bool($memory)
  validate_bool($network)
  validate_bool($apache)
  validate_bool($postgresql)
  validate_bool($swap)
  validate_bool($user)

  class { '::collectd':
    purge        => true,
    recurse      => true,
    purge_config => true,
  }

  if ($apache) {
    if not defined(Class['profile::apache']) {
      fail('Apache is not defined')
    } else {
      include ::collectd::plugin::apache
    }
  }

  if ($disk) {
    include ::collectd::plugin::df
  }

  if ($entropy) {
    include ::collectd::plugin::entrophy
  }

  if ($load) {
    include ::collectd::plugin::load
  }

  if ($memory) {
    include ::collectd::plugin::memory
  }

  if ($network) {
    include ::collectd::plugin::interface
  }

  if ($postgresql) {
    if not defined(Class['profile::postgresql']) {
      fail('PostgreSQL is not defined')
    } else {
      include ::collectd::plugin::postgresql
    }
  }

  if ($swap) {
    include ::collectd::plugin::swap
  }

  if ($user) {
    include ::collectd::plugin::user
  }
}

