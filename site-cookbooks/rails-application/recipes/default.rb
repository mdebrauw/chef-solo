#
# Cookbook Name:: rails-app
# Recipe:: default
#
# Copyright 2012, Debrauw.net
#
# All rights reserved - Do Not Redistribute
#

# Load databag for application
#
node.set['application'] = Chef::DataBagItem.load('default', node["application"]["id"])

# Install bundler gem
#
execute "gem-install-bundler" do
  user "root"
  command "gem install bundler"
end

# Deploy identity (private key), as stored in data bag on target node
#
directory "/tmp/private_code/.ssh" do
  owner "root"
  recursive true
end

file "/tmp/private_code/.ssh/id_deploy" do
  content node['application']['deploy_key']
  owner "root"
  mode 0600
end

# Deploy ssh wrapper script to use deploy identity
#
cookbook_file "/tmp/private_code/wrap-ssh4git.sh" do
  source "wrap-ssh4git.sh"
  owner "root"
  mode 0700
end

deploy "#{node['application']['deploy_to']}" do
  repo node['application']['repository']
  revision node['application']['revision']
  enable_submodules true
  symlink_before_migrate.clear
  migrate node['application']['migrate']
  migration_command node['application']['migration_command']
  environment "RAILS_ENV" => node['application']['environment']
  shallow_clone true
  action :deploy # :rollback
  restart_command "touch tmp/restart.txt"
  git_ssh_wrapper "/tmp/private_code/wrap-ssh4git.sh"

  before_restart do
    current_release_directory = release_path
    running_deploy_user = new_resource.user
    bundler_depot = new_resource.shared_path + '/bundle'
    excluded_groups = "--without #{%w(development test).join(' ')}" if node["application"]["environment"] == "production"
    environment = new_resource.environment["RAILS_ENV"]

    script 'Bundling the gems' do
      interpreter 'bash'
      cwd current_release_directory
      user running_deploy_user
      code <<-EOS
        bundle install --quiet --deployment --path #{bundler_depot} \
        #{excluded_groups}
      EOS
    end

    script 'Precompiling the assets' do
      interpreter 'bash'
      cwd current_release_directory
      user running_deploy_user
      code <<-EOS
        bundle exec rake assets:precompile RAILS_ENV=#{environment} RAILS_GROUPS=assets
      EOS
    end

    # Deploy virtual server file for nginx
    template "#{node['application']['id']}" do
      path "/opt/nginx/sites-available/#{node['application']['id']}"
      source "virtual_server.erb"
      owner "root"
      group "root"
      mode "0644"
    end

    # Symlink it to enable it for nginx
    link "/opt/nginx/sites-enabled/#{node['application']['id']}" do
      to "/opt/nginx/sites-available/#{node['application']['id']}"
    end

    # Change ownership of deployed application files
    execute "Change owner of application files" do
      cwd '/srv'
      command "sudo chown -R www-data:www-data #{node['application']['id']}"
      action :run
    end

  end
end

service "nginx" do
  action [ :restart ]
end




