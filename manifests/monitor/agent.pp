class profile::monitor::agent(
  $backend,
  $apache = false,
  $cpu = true,
  $disk = true,
  $entropy = true,
  $load = true,
  $memory = true,
  $network = true,
  $postgresql = false,
  $swap = true,
  $users = true,
) {
  validate_bool($apache)
  validate_bool($backend)
  validate_bool($disk)
  validate_bool($entropy)
  validate_bool($load)
  validate_bool($memory)
  validate_bool($network)
  validate_bool($apache)
  validate_bool($postgresql)
  validate_bool($swap)
  validate_bool($users)

  class { '::collectd':
    purge        => true,
    recurse      => true,
    purge_config => true,
  }

  if ($apache) {
    if !defined(Class['profile::apache']) {
      fail('Apache is not defined')
    } else {
      include ::collectd::plugin::apache
    }
  }

  if ($backend) {
    collectd::plugin::write_graphite::carbon { $backend:
      graphitehost => $backend,
    }
  }

  if ($cpu) {
    include ::collectd::plugin::cpu
  }

  if ($disk) {
    include ::collectd::plugin::df
  }

  if ($entropy) {
    include ::collectd::plugin::entropy
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
    if !defined(Class['profile::postgresql']) {
      fail('PostgreSQL is not defined')
    } else {
      include ::collectd::plugin::postgresql
    }
  }

  if ($swap) {
    include ::collectd::plugin::swap
  }

  if ($users) {
    include ::collectd::plugin::users
  }
}

