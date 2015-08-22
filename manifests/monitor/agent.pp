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
  $processes = true,
  $swap = true,
  $users = true,
) {
  validate_bool($apache)
  validate_string($backend)
  validate_bool($disk)
  validate_bool($entropy)
  validate_bool($load)
  validate_bool($memory)
  validate_bool($network)
  validate_bool($apache)
  validate_bool($postgresql)
  validate_bool($processes)
  validate_bool($swap)
  validate_bool($users)

  class { '::collectd':
    fqdnlookup   => false,
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

  if ($cpu) {
    class { '::collectd::plugin::cpu':
      interval         => 1,
      reportbycpu      => false,
      reportbystate    => false,
      valuespercentage => true,
    }
  }

  if ($disk) {
    class { '::collectd::plugin::df':
      interval         => 1,
      reportinodes     => false,
      valuesabsolute   => false,
      valuespercentage => true,
    }
  }

  if ($entropy) {
    class { '::collectd::plugin::entropy':
      interval => 1
    }
  }

  if ($load) {
    class { '::collectd::plugin::load':
      interval => 1
    }
  }

  if ($memory) {
    class { '::collectd::plugin::memory':
      interval         => 1,
      valuesabsolute   => false,
      valuespercentage => true,
    }
  }

  if ($network) {
    class { '::collectd::plugin::interface':
      interval => 1
    }
  }

  if ($postgresql) {
    if !defined(Class['profile::postgresql']) {
      fail('PostgreSQL is not defined')
    } else {
      include ::collectd::plugin::postgresql
    }
  }

  if ($processes) {
    class { '::collectd::plugin::processes':
      interval => 1
    }
  }

  if ($swap) {
    class { '::collectd::plugin::swap':
      interval         => 1,
      valuesabsolute   => false,
      valuespercentage => true
    }
  }

  if ($users) {
    class { '::collectd::plugin::users':
      interval => 1
    }
  }

  if ($backend) {
    collectd::plugin::write_graphite::carbon { $backend:
      graphitehost      => $backend,
      separateinstances => true,
    }
  }
}
