#require 'rails/generators/actions'

# Fall 2012 - next time, switch name and proejct
#                         
# next time, create lib/tasks/build_machine.rake
# next time, create goldberg_config file

# Script....that will create a project in the root directoyr and move to done when done!
# mkdir done
# thor student_project_factory:create PET Mavericks
# thor student_project_factory:create BestBay Business-As-Usual

class StudentProjectFactory < Thor
  include Thor::Actions

  @@course = "96821" #ISE
#  @@course = "96700" #FSE
#  @@course = "18642" #ECE
  @@year = "2012"

  desc "create PROJECT, TEAM_NAME", "create a team project"
  # This creates directory shell, and then does the heavy lifting in the next method
  def create(project, name)
    project_directory = "Fall-" + @@year + "-" + @@course + "-" + name
#    yes? "We're going to create a project called " + project_directory + " (press return)"
    empty_directory project_directory
    run "cd " + project_directory + "; thor student_project_factory:create_project " + project + " " + name
    say "------------------------------"
    say "Finished with " + project_directory
    say "------------------------------"
    say "cd " + project_directory
    say "----- yes! to rvm"
    say "bundle install"
    say "script/rails generate rspec:install"
    say "rake db:migrate"
    say "git add ."
    say "git commit -m 'Adding in rspec'"
    say "git remote add origin git@github.com:cmusv/" + project_directory + ".git"
    say "git push origin master"
    say "cd .."
    say "mv " + project_directory + " done"
    say "------------------------------"
  end

  desc "create_project TEAM_NAME", "create a team project"
  def create_project(project, name)
    project_directory = "Fall-" + @@year + "-" + @@course + "-" + name
    run "git init"
    run "rails new " + project + " -v 3.2.7 --skip-test-unit"
    run "mv " + project + "/* ."
    run "mv " + project + "/.[^.]* ." #Move .files
    remove_dir project
    update_gemfile
    update_git_file
    create_rvmrc
    modify_readme_with_build_status name
    rename_readme
    run "git add ."
    run "git commit -m 'Adding in initial repo'"
  end



  protected
  def update_git_file
#    create_file ".gitignore"
    append_to_file ".gitignore" do
      "\n" +
#      ".bundle\n" +
#      "db/*.sqlite3\n" +
#      "log/*.log\n" +
#      "tmp/\n"+
#      "tmp/*\n" +
      "webrat.log\n" +
      ".idea/*\n" +
      "coverage/*\n" +
      "doc/coverage/*\n" +
      "*DS_Store\n" +
      ".rspec\n"
    end
  end

  def update_gemfile
    insert_into_file "Gemfile", :before => "gem 'sqlite3'", do
      "group :development, :test do\n   "
    end
    insert_into_file "Gemfile", :after => "gem 'sqlite3'", do
      "\n" +
      "end\n" +
      "\n" +
      "group :production do\n" +
      "  gem 'pg'\n" +
      "end\n"
    end
    append_to_file "Gemfile" do
      "\n"+
      "#suggested gems by Todd\n" +
      "gem 'factory_girl_rails' \n" +
      "gem 'rspec-rails' \n" +
      "gem 'devise' \n" +
      "group :development do\n" +
      "  gem 'ruby-debug19' \n" +
      "  gem 'ruby-debug-base19x' \n" +
      "  gem 'ruby-debug-ide' #'0.4.6' \n" +
      "end\n"
    end

  end

  def create_rvmrc
    create_file ".rvmrc" do
      "rvm --create use ruby-1.9.3-p194@cmucourse\n"
    end
  end

  def modify_readme_with_build_status(team_name)
    insert_into_file "README.rdoc", :after => "== Welcome to Rails" do
       ""
#      "\n     <a href='http://cruise.sv.cmu.edu:3333/projects/#{team_name}'><img src='http://cruise.sv.cmu.edu:3333/projects/#{team_name}.png' alt='Build Status'></a> \n "
    end

  end

  def rename_readme
    run "mv README.rdoc README.md"
  end


#   RAILS_ENV=production bin/goldberg add git@github.com:cmusv/Fall-2011-FSE-Alpha-and-Omega.git Alpha-and-Omega

#  RAILS_ENV=production bin/goldberg add git@github.com:cmusv/Fall-2011-FSE-Mavericks.git Mavericks
# RAILS_ENV=production bin/goldberg add https://professor@github.com/cmusv/Fall-2011-FSE-Mavericks.git Mavericks
#
# On server
# cd goldberg
# RAILS_ENV=production rails server --port 3333
  # god -c config/god-script.rb -D
# RAILS_ENV="production"  bin/goldberg start_poller

# RAILS_ENV=production bin/goldberg remove PROJECT
end


# 
#  mkdir Fall-2010-FSE-Rail-ARCS
#   cd Fall-2010-FSE-Rail-ARCS
# 
# (For next year, also create a lib/tasks/rails_rcov.rake file)
# git init;   rails _2.3.8_ OASP; cd OASP; mv * ..; cd ..; rmdir OASP; cp ../.gitignore .;  mkdir lib/tasks ; cp ../cruise.rake lib/tasks; git add .;   git commit -m 'Adding in rails 2.3.8'
# 
#   git remote add origin git@git