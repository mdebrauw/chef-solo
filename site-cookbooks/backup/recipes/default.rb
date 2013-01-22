package "backupninja"
package "s3cmd"
package "duplicity"
package "python-boto"

# Deploy backup script
#
template "#{node['backup']['backup_script_path']}/dt-s3-backup.sh" do
  source "dt-s3-backup.sh.erb"
  owner "root"
  mode 0700
end

# Deploy the mysql backup.d script
#
template "/etc/backup.d/20.mysql" do
  source "20.mysql.erb"
  owner "root"
  mode 0700
end

# Deploy the S3 config
#
template "/root/.s3cfg" do
  source "s3cfg.erb"
  owner "root"
  mode 0600
end

# Deploy the filesystem backup backup.d script
#
template "/etc/backup.d/30.filesystem_to_s3.sh" do
  source "30.filesystem_to_s3.sh.erb"
  owner "root"
  mode 0700
end

# Temporarily store secret key for import and remove it afterwards
#
directory "/tmp/backup" do
  owner "root"
  recursive true
end

cookbook_file "/tmp/backup/s3-secret.key.txt" do
  source "s3-secret.key.txt"
  owner "root"
  mode 0600
end

execute "Import secret key" do
  cwd '/tmp/backup'
  command "gpg --allow-secret-key-import --import s3-secret.key.txt"
  action :run
end

file "/tmp/backup/s3-secret.key.txt" do
  action :delete
end
