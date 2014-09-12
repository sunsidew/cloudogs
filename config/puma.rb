#environment 'development'
#daemonize false
rails_env = ENV['RAILS_ENV'] || 'development'
#pidfile 'tmp/pids/puma.pid'
#state_path 'tmp/pids/puma.state'

threads 0, 10000
#bind 'unix://tmp/sockets/puma.sock'
