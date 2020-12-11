resource_name :elasticbeat_instance
default_action :create

property :destination_type, String, required: true
property :destination_url, String, required: true
property :beat_type, String, required: true
property :config_content, String
property :config, String
property :modules, [String, Array]
property :template_cookbook, String, default: 'elasticbeat'

action :create do
  include_recipe 'elasticbeat::elastic_repo'

  base_dir = "/etc/#{new_resource.beat_type}beat"
  instance_dir = "#{base_dir}/#{new_resource.name}"
  modules_dir = "#{instance_dir}/modules.d"

  package "#{new_resource.beat_type}beat" do
    action :install
    notifies :create, "directory[#{instance_dir}]", :immediately
    notifies :create, "directory[#{modules_dir}]", :immediately
    notifies :run, 'execute[copy fields.yml]', :immediately
    notifies :run, 'execute[copy modules]', :immediately
  end

  directory instance_dir do
    user 'root'
    group 'root'
    mode 0755
    action :nothing
  end

  directory modules_dir do
    user 'root'
    group 'root'
    mode 0755
    action :nothing
  end

  execute 'copy fields.yml' do
    command "if [ -f #{base_dir}/fields.yml ]; then cp #{base_dir}/fields.yml #{instance_dir}/fields.yml; fi"
    action :nothing
  end

  execute 'copy modules' do
    command "if [ -d #{base_dir}/modules.d ]; then cp #{base_dir}/modules.d/* #{modules_dir}; fi"
    action :nothing
  end

  template "/etc/systemd/system/#{new_resource.beat_type}beat@.service" do
    source 'elasticbeat@.service.erb'
    cookbook new_resource.template_cookbook
    user 'root'
    group 'root'
    variables(
      beat_type: new_resource.beat_type
    )
    notifies :run, 'execute[systemctl daemon-reload]', :immediately
    notifies :restart, "service[#{new_resource.beat_type}beat@#{new_resource.name}]"
  end

  execute 'systemctl daemon-reload' do
    command '/bin/systemctl daemon-reload'
    action :nothing
  end

  if new_resource.config.nil?
    file "#{instance_dir}/#{new_resource.beat_type}beat.yml" do
      content new_resource.config_content
      notifies :restart, "service[#{new_resource.beat_type}beat@#{new_resource.name}]", :immediately
    end
  else
    cookbook_file "#{instance_dir}/#{new_resource.beat_type}beat.yml" do
      source new_resource.config
      notifies :restart, "service[#{new_resource.beat_type}beat@#{new_resource.name}]", :immediately
    end
  end

  service "#{new_resource.beat_type}beat@#{new_resource.name}" do
    action [:enable, :start]
  end
end
