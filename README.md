# elasticbeat

Manage multiple instances of Elastic Beats with Systemd dropins.

## Example

    config = '---
    filebeat.inputs:
      - type: log
        enabled: true
        paths:
          - /var/log/some-service/events.log
        fields:
          type: "foo"
        fields_under_root: true

    output.elasticsearch:
      hosts: ["foo.com"]'

    filebeat_instance 'foo' do
      config_content config
    end

# Lint Checking
Run the following from the root of the repo:

    chef exec foodcritic .

    chef exec cookstyle .

# Unit Tests
Run the following from the root of the repo:

    chef exec rspec

# Integration Tests
Run the following from the root of the repo:

    kitchen test
