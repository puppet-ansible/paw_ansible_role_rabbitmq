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
  String $rabbitmq_apt_repository = 'https://ppa1.rabbitmq.com/rabbitmq/rabbitmq-server/deb/{{ ansible_distribution | lower }}',
  String $rabbitmq_apt_gpg_url = 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key',
  String $erlang_apt_repository = 'https://ppa1.rabbitmq.com/rabbitmq/rabbitmq-erlang/deb/{{ ansible_distribution | lower }}',
  String $erlang_apt_gpg_url = 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key',
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
  $vardir = $facts['puppet_vardir'] ? {
    undef   => $settings::vardir ? {
      undef   => '/opt/puppetlabs/puppet/cache',
      default => $settings::vardir,
    },
    default => $facts['puppet_vardir'],
  }
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/ansible_role_rabbitmq/playbook.yml"

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
