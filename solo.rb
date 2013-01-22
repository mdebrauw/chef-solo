root = File.expand_path(File.dirname(__FILE__))

file_cache_path root
cookbook_path   File.join(root, "cookbooks"), File.join(root, "site-cookbooks")
role_path File.join(root, "roles")
data_bag_path File.join(root, "data_bags")
