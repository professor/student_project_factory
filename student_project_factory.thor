#require 'rails/generators/actions'

class StudentProjectFactory < Thor
  include Thor::Actions

  @@course = "FSE"

  desc "create TEAM_NAME PROJECT", "create a team project"
  # This creates directory shell, and then does the heavy lifting in the next method
  def create(name, project)
    project_directory = "Fall-2011-" + @@course + "-" + name
#    yes? "We're going to create a project called " + project_directory + " (press return)"
    empty_directory project_directory
    run "cd " + project_directory + "; thor student_project_factory:create_project " + name + " " + project
    say "Finished with " + project_directory
    say "bundle install"
    say "rails generate jquery:install"
    say "script/rails generate rspec:install"
    say "rake db:migrate"
    run "git add ."
    run "git commit -m 'Adding in jquery and rspec'"
    say "git remote add origin git@github.com:cmusv/" + project_directory + ".git"
    say "git push origin master"
  end

  desc "create_project TEAM_NAME", "create a team project"

  def create_project(name, project)
    project_directory = "Fall-2011-" + @@course + "-" + name
    run "git init"
    run "rails new " + project + " -v 3.0.9 --skip-testunit --skip-prototype"
    run "mv " + project + "/* ."
    remove_dir project
    update_gemfile
    update_git_file
    create_rvmrc
    modify_readme_with_build_status project_directory
    rename_readme
    run "git add ."
    run "git commit -m 'Adding in initial repo'"
  end



  protected
  def update_git_file
    create_file ".gitignore"
    append_to_file ".gitignore" do
      ".bundle\n" +
      "db/*.sqlite3\n" +
      "log/*.log\n" +
      "tmp/\n"+
      ".idea/*\n" +
      "coverage/*\n" +
      "doc/coverage/*\n" +
      "tmp/*\n" +
      "*DS_Store\n" +
      ".rspec\n" +
      ".bundle\n"
    end
  end

  def update_gemfile
    append_to_file "Gemfile" do
      "\n"+
      "#suggested gems by Todd\n" +
      "gem 'jquery-rails', '>= 1.0.3'\n" +
      "gem 'factory_girl_rails' \n" +
      "gem 'rspec-rails' \n" +
      "gem 'devise' \n" +
      "gem 'ruby-debug19' \n" +
      "gem 'ruby-debug-base19x' \n" +
      "gem 'ruby-debug-ide' #'0.4.6' \n"
    end
  end

  def create_rvmrc
    create_file ".rvmrc" do
      "rvm --create use ruby-1.9.2-p180@cmucourse\n"
    end
  end

  def rename_readme
    run "mv README README.md"
  end

  def modify_readme_with_build_status(project_directory)
    insert_into_file "README", :after => "== Welcome to Rails" do
      "\n     <a href='http://cruise.sv.cmu.edu:3000/projects/#{project_directory}'><img src='http://cruise.sv.cmu.edu:3000/projects/#{project_directory}.png' alt='Build Status'></a> \n "
    end

  end


#  RAILS_ENV=production bin/goldberg add git@github.com:cmusv/Fall-2011-FSE-Mavericks.git Fall-2011-FSE-Mavericks
# RAILS_ENV=production bin/goldberg add https://professor@github.com/cmusv/Fall-2011-FSE-Mavericks.git Fall-2011-FSE-Mavericks
#
# On server
# cd goldberg
# RAILS_ENV=production rails server
  # god -c config/god-script.rb -D
# RAILS_ENV="production"  bin/goldberg start_poller


end


# 
#  mkdir Fall-2010-FSE-Rail-ARCS
#   cd Fall-2010-FSE-Rail-ARCS
# 
# (For next year, also create a lib/tasks/rails_rcov.rake file)
# git init;   rails _2.3.8_ OASP; cd OASP; mv * ..; cd ..; rmdir OASP; cp ../.gitignore .;  mkdir lib/tasks ; cp ../cruise.rake lib/tasks; git add .;   git commit -m 'Adding in rails 2.3.8'
# 
#   git remote add origin git@git