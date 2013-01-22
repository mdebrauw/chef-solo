# Variables
app_name_databag = Chef::DataBagItem.load('default', 'app_name')

# Description
name "app_name_development"
description "app_name development server"

# Run list
run_list(
  "recipe[base]",
  "recipe[git]",
  "recipe[nginx::source]",
  "recipe[mongodb]",
  "recipe[app_name]",
  "recipe[rails-application]",
  "recipe[backup]"
)

# Default attributes for cookbooks
default_attributes "application" => {
    "id" => "app_name",
    "environment" => "production",
    "database_user_password" => app_name_databag["application"]["database_user_password"],
    "domain" => "app_name.local",
    "repository" => "git@github.com:your_name/your_repo.git",
    "revision" => "master",
    "deploy_to" => "/srv/app_name",
    "migrate" => false,
    "migration_command" => "rake db:migrate"
  },
  "backup" => {
    "aws_access_key_id" => app_name_databag["backup"]["aws_access_key_id"],
    "aws_secret_access_key" => app_name_databag["backup"]["aws_secret_access_key"],
    "passphrase" => app_name_databag["backup"]["passphrase"],
    "dest" => "s3+http://app_name-backup-dev/",
    "gpg_key" => "94E232B1",
    "email_to" => "you@you.com",
    "inc_list" => "/srv/app_name",
    "exc_list" => "/srv/app_name/releases"
  },
  "users" => [ "mark" ],
  "openssh" => {
    "server" => {
      "host_key" => "/etc/ssh/ssh_host_dsa_key",
      "host_key" => "/etc/ssh/ssh_host_ecdsa_key",
      "host_key" => "/etc/ssh/ssh_host_rsa_key",
      "key_regeneration_interval" => "3600",
      "login_grace_time"  => "120",
      "host_based_authentication" => "no",
      "ignore_rhosts" => "yes",
      "keep_alive" => "yes",
      "log_level" => "INFO",
      "password_authentication" => "no",
      "permit_root_login" => "no",
      "permit_empty_passwords" => "no",
      "port" => "22",
      "protocol" => "2",
      "print_lastlog" => "no",
      "print_motd" => "no",
      "pub_key_authentication" => "yes",
      "rhosts_rsa_authentication" => "no",
      "rsa_authentication" => "yes",
      "server_key_bits" => "1024",
      "strict_modes" => "yes",
      "syslog_facility" => "AUTH",
      "allow_groups" => "ssh_login"
    }
  }

# Overrides for cookbooks
override_attributes "firewall" => {
  "rules" => [
    { "block all" => { "direction" => "in", "action" => "deny" }},
    {"http" => { "port" => "80"}},
    {"https" => { "port" => "443"}},
    {"ssh" => { "port" => "22"}},
    {"3000" => { "port" => "3000"}} ]
  },
  "nginx" => {
    "source" => { "modules" => [ "http_ssl_module", "http_gzip_static_module", "passenger" ] },
    # Override this attribute as the default is not correct for Ubuntu 12.04 LTS
    "passenger" => { "root" => "/opt/ruby/lib/ruby/gems/1.9.1/gems/passenger-3.0.12/" }
  }
