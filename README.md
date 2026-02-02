# paw_ansible_role_rabbitmq

## Description

This Puppet module was Converted from Ansible role: **ansible_role_rabbitmq**

RabbitMQ installation for Linux.

## Conversion Details

- **Converted on**: 2026-02-02
- **Original Author**: geerlingguy
- **License**: license (BSD, MIT)

## Usage

Include the module in your Puppet manifest:

```puppet
include paw_ansible_role_rabbitmq
```

Or with custom parameters:

```puppet
class { 'paw_ansible_role_rabbitmq':
  # Add your parameters here
}
```

## Parameters

See `manifests/init.pp` for the full list of available parameters.

## Requirements

- Puppet 6.0 or higher
- puppet_agent_runonce module for task execution
- Ansible installed on target nodes for task execution

## License

license (BSD, MIT)
