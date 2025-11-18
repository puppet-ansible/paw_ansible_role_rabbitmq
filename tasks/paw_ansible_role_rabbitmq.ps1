# Puppet task for executing Ansible role: ansible_role_rabbitmq
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_rabbitmq"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_rabbitmq"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_rabbitmq\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_rabbitmq"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_rabbitmq"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_rabbitmq_daemon) {
  $ExtraVars['rabbitmq_daemon'] = $env:PT_rabbitmq_daemon
}
if ($env:PT_rabbitmq_state) {
  $ExtraVars['rabbitmq_state'] = $env:PT_rabbitmq_state
}
if ($env:PT_rabbitmq_enabled) {
  $ExtraVars['rabbitmq_enabled'] = $env:PT_rabbitmq_enabled
}
if ($env:PT_rabbitmq_version) {
  $ExtraVars['rabbitmq_version'] = $env:PT_rabbitmq_version
}
if ($env:PT_rabbitmq_rpm) {
  $ExtraVars['rabbitmq_rpm'] = $env:PT_rabbitmq_rpm
}
if ($env:PT_rabbitmq_rpm_url) {
  $ExtraVars['rabbitmq_rpm_url'] = $env:PT_rabbitmq_rpm_url
}
if ($env:PT_rabbitmq_rpm_gpg_url) {
  $ExtraVars['rabbitmq_rpm_gpg_url'] = $env:PT_rabbitmq_rpm_gpg_url
}
if ($env:PT_rabbitmq_apt_repository) {
  $ExtraVars['rabbitmq_apt_repository'] = $env:PT_rabbitmq_apt_repository
}
if ($env:PT_rabbitmq_apt_gpg_url) {
  $ExtraVars['rabbitmq_apt_gpg_url'] = $env:PT_rabbitmq_apt_gpg_url
}
if ($env:PT_erlang_apt_repository) {
  $ExtraVars['erlang_apt_repository'] = $env:PT_erlang_apt_repository
}
if ($env:PT_erlang_apt_gpg_url) {
  $ExtraVars['erlang_apt_gpg_url'] = $env:PT_erlang_apt_gpg_url
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_rabbitmq"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_rabbitmq"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}
