#require 'rails/generators/actions'

class StudentProjectsFactory < Thor
  include Thor::Actions

  desc "create TEAM_NAME PROJECT", "create a team project"      
  # This creates directory shell, and then does the heavy lifting in the next method
  def create(name, project) 
    project_directory = "Fall-2011-FSE-" + name
#    yes? "We're going to create a project called " + project_directory + " (press return)"
    empty_directory project_directory                                   
	run "cd " + project_directory  + "; thor student_projects_factory:create_project " + name + " " + project

  end

  desc "create_project TEAM_NAME", "create a team project"
  def create_project(name, project) 
    run "git init"             
	run "rails _3.0.9_ " + project
    run "mv " + project + "/* ."
    remove_dir project
    create_git_file 
  end
     
  protected
  def create_git_file
    create_file ".gitignore"
    append_to_file ""                    
	# .bundle
	# .gems
	# .gems_old
	# Gemfile.lock
	# 
	# config/database.yml
	# 
	# doc/coverage/*
	# coverage/*
	# log/*
	# nbproject/*
	# .idea/*
	# tmp/*
	# 
	# *DS_Store

  end


end


# 
#  mkdir Fall-2010-FSE-Rail-ARCS
#   cd Fall-2010-FSE-Rail-ARCS
# 
# (For next year, also create a lib/tasks/rails_rcov.rake file)
# git init;   rails _2.3.8_ OASP; cd OASP; mv * ..; cd ..; rmdir OASP; cp ../.gitignore .;  mkdir lib/tasks ; cp ../cruise.rake lib/tasks; git add .;   git commit -m 'Adding in rails 2.3.8'
# 
#   git remote add origin git@git