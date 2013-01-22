# Run bundle install
execute "run-bundle-install" do
  cwd "/vagrant"
  command "bundle install"
end

# Start Rails webbrick server
execute "start-webbrick-server" do
  cwd "/vagrant"
  command "rails s -d"
end

# Start Resque web interface
execute "start-resque-web-interface" do
  cwd "/vagrant"
  command "resque-web"
end

# Start Resque workers
execute "start-resque-workers" do
  cwd "/vagrant"
  command "PIDFILE=/tmp/resque.pid BACKGROUND=yes QUEUE=* rake resque:work"
end
