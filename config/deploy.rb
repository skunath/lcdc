set :application, "lcdc_2"
set :repository,  "git@github.com:skunath/lcdc.git"

set :scm, :git
set :user, "sak68"
ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "/opt/software/rail_apps/#{application}"  
set :use_sudo, false  
role :web, "armstrong.arc.georgetown.edu"                          # Your HTTP server, Apache/etc
role :app, "armstrong.arc.georgetown.edu"                          # This may be the same as your `Web` server
default_run_options[:pty] = true


on :start do
    `ssh-add`
end

#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end



namespace :deploy do
  desc "Override deploy:cold to NOT run migrations - there's no database"
  task :cold do
    update
    start
  end
end


before "deploy:setup", "db:configure"
after "deploy:update_code", "db:symlink"


set(:development_database) { "lcdc" }
set(:test_database) { application + "_test" }
set(:production_database) { "lcdc" }

namespace :db do
  desc "Create database yaml in shared path"
  task :configure do
    set :database_username do
      Capistrano::CLI.password_prompt "Database Username: "
    end
    
    set :database_password do
      Capistrano::CLI.password_prompt "Database Password: "
    end
    
    
    db_config = <<-EOF
development:
  database: #{development_database}
  adapter: mysql2
  encoding: utf8
  username: #{database_username}
  password: #{database_password}

test:
  database: #{test_database}
  adapter: mysql2
  encoding: utf8
  username: #{database_username}
  password: #{database_password}

production:
  database: #{production_database}
  adapter: mysql2
  encoding: utf8
  username: #{database_username}
  password: #{database_password}


EOF

    run "mkdir -p #{shared_path}/config"
    put db_config, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end
end





