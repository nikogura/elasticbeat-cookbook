filebeat_config = '---
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/some-service/events.log
    fields:
      type: "fargle"
    fields_under_root: true

output.elasticsearch:
  hosts: ["foo.com"]'

elasticbeat_instance 'foo' do
  beat_type 'file'
  config_content filebeat_config
end

journalbeat_config = '---
journalbeat.inputs:
  - paths: []
output.elasticsearch:
  hosts: ["foo.com"]'

elasticbeat_instance 'bar' do
  beat_type 'journal'
  config_content journalbeat_config
end
