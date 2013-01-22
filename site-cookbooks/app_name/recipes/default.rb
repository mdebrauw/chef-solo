# Provision app_name package dependencies
#
package "libxslt-dev"
package "libxml2-dev"
package "libmagic-dev"
package "libmagickwand-dev"

Provision app_name database dependencies, run prior to rails-application deployment cookbook

mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}
database = "#{node["application"]["id"]}_#{node["application"]["environment"]}"

Create MySQL database

mysql_database database do
  connection mysql_connection_info
  action :create
end

Create MySQL database user

mysql_database_user "app_#{node["application"]["id"]}" do
  connection mysql_connection_info
  password node["application"]["database_user_password"]
  database_name database
  # host '%'
  action :grant
end
