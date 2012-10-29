#require 'rails/generators/actions'

# thor student_project_factory:add_goldberg_project

class GoldbergProjectFactory < Thor
  include Thor::Actions



  desc "add_goldberg_project COURSE_NUMBER, TEAM_NAME, email, github_url,", "git@github.com:cmusv/Fall-2012-96700-Lions.git Lions"
  def add_goldberg_project(course_number, team_name, team_email, github_url)
    Dir.chdir("/Users/build/goldberg")
    run "RAILS_ENV=production /Users/build/goldberg/bin/goldberg add " + github_url + " " + team_name
    goldberg_project_directory = "/Users/build/.goldberg/projects/"
    goldberg_project_file = goldberg_project_directory + team_name + "/code/goldberg_config.rb"
    create_file goldberg_project_file do
      "\n" +

    end

  end


end


