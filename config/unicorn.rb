worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)

# Since Unicorn is never exposed to outside clients, it does not need to
# run on the standard HTTP port (80), there is no reason to start Unicorn
# as root unless it's from system init scripts.
# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
# working_directory "/path/to/app/current" # available in 0.94.0+

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
# listen "/var/www/apps/gate/shared/tmp/sockets/.unicorn.sock", backlog: 64
listen ENV['PORT'], tcp_nopush: true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# feel free to point this anywhere accessible on the filesystem
# pid "/var/www/apps/gate/shared/tmp/pids/unicorn.pid"

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
# stderr_path "/var/www/apps/gate/shared/log/unicorn.stderr.log"
# stdout_path "/var/www/apps/gate/shared/log/unicorn.stdout.log"

# combine Ruby 2.0.0+ with "preload_app true" for memory savings
preload_app true

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
# check_client_connection false

# local variable to guard against running a hook multiple times
run_once = true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end
  
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  if run_once
    # do_something_once_here ...
    run_once = false # prevent from firing again
  end

  
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end
  
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end