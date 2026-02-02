# paw_ansible_role_rabbitmq
# @summary Manage paw_ansible_role_rabbitmq configuration
#
# @param rabbitmq_daemon
# @param rabbitmq_state
# @param rabbitmq_enabled
# @param rabbitmq_version
# @param rabbitmq_rpm
# @param rabbitmq_rpm_url
# @param rabbitmq_rpm_gpg_url
# @param rabbitmq_apt_repository
# @param rabbitmq_apt_gpg_url
# @param erlang_apt_repository
# @param erlang_apt_gpg_url
# @param par_vardir Base directory for Puppet agent cache (uses lookup('paw::par_vardir') for common config)
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_rabbitmq (
  String $rabbitmq_daemon = 'rabbitmq-server',
  String $rabbitmq_state = 'started',
  Boolean $rabbitmq_enabled = true,
  String $rabbitmq_version = '3.12.2',
  String $rabbitmq_rpm = 'rabbitmq-server-{{ rabbitmq_version }}-1.el8.noarch.rpm',
  String $rabbitmq_rpm_url = 'https://github.com/rabbitmq/rabbitmq-server/releases/download/v{{ rabbitmq_version }}/{{ rabbitmq_rpm }}',
  String $rabbitmq_rpm_gpg_url = 'https://www.rabbitmq.com/rabbitmq-release-signing-key.asc',
  String $rabbitmq_apt_repository = 'https://deb1.rabbitmq.com/rabbitmq-server/{{ ansible_facts.distribution | lower }}/{{ ansible_facts.distribution_release }}',
  String $rabbitmq_apt_gpg_url = 'https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA',
  String $erlang_apt_repository = 'https://deb1.rabbitmq.com/rabbitmq-erlang/{{ ansible_facts.distribution | lower }}/{{ ansible_facts.distribution_release }}',
  String $erlang_apt_gpg_url = 'https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA',
  Optional[Stdlib::Absolutepath] $par_vardir = undef,
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
# Playbook synced via pluginsync to agent's cache directory
# Check for common paw::par_vardir setting, then module-specific, then default
  $_par_vardir = $par_vardir ? {
    undef   => lookup('paw::par_vardir', Stdlib::Absolutepath, 'first', '/opt/puppetlabs/puppet/cache'),
    default => $par_vardir,
  }
  $playbook_path = "${_par_vardir}/lib/puppet_x/ansible_modules/ansible_role_rabbitmq/playbook.yml"

  par { 'paw_ansible_role_rabbitmq-main':
    ensure        => present,
    playbook      => $playbook_path,
    playbook_vars => {
      'rabbitmq_daemon'         => $rabbitmq_daemon,
      'rabbitmq_state'          => $rabbitmq_state,
      'rabbitmq_enabled'        => $rabbitmq_enabled,
      'rabbitmq_version'        => $rabbitmq_version,
      'rabbitmq_rpm'            => $rabbitmq_rpm,
      'rabbitmq_rpm_url'        => $rabbitmq_rpm_url,
      'rabbitmq_rpm_gpg_url'    => $rabbitmq_rpm_gpg_url,
      'rabbitmq_apt_repository' => $rabbitmq_apt_repository,
      'rabbitmq_apt_gpg_url'    => $rabbitmq_apt_gpg_url,
      'erlang_apt_repository'   => $erlang_apt_repository,
      'erlang_apt_gpg_url'      => $erlang_apt_gpg_url,
    },
    tags          => $par_tags,
    skip_tags     => $par_skip_tags,
    start_at_task => $par_start_at_task,
    limit         => $par_limit,
    verbose       => $par_verbose,
    check_mode    => $par_check_mode,
    timeout       => $par_timeout,
    user          => $par_user,
    env_vars      => $par_env_vars,
    logoutput     => $par_logoutput,
    exclusive     => $par_exclusive,
  }
}
