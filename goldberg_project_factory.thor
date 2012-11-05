#require 'rails/generators/actions'

# We are not able to create the goldberg project from thor, you need to run the command manually
# thor student_project_factory:add_goldberg_project

# thor goldberg_project_factory:add_goldberg_project 96821 RckStrz fall-2012-rckstrz@sv.cmu.edu git@github.com:cmusv/Fall-2012-96821-RckStrz.git

class GoldbergProjectFactory < Thor
  include Thor::Actions


  desc "add_goldberg_project COURSE_NUMBER, TEAM_NAME, email, github_url,", "git@github.com:cmusv/Fall-2012-96700-Lions.git Lions"
  def add_goldberg_project(course_number, team_name, team_email, github_url)
    # Dir.chdir("/Users/build/goldberg")
    
    run "RAILS_ENV=production /Users/build/goldberg/bin/goldberg add " + github_url + " " + team_name
    ask "Did you run the goldberg command manually?"

    goldberg_project_directory = "/Users/build/.goldberg/projects/"
    goldberg_project_file = goldberg_project_directory + team_name + "/code/goldberg_config.rb"

    copy_file "goldberg_config.rb", goldberg_project_file
    copy_file "build_machine.rake", goldberg_project_directory + "code/lib/tasks/build_machine.rake"
    insert_into_file goldberg_project_file, :before => "    from = " do
    # append_to_file goldberg_project_file do
      "\n" +
      "     config.group = '" + course_number + "' \n" +
      "     email = \"" + team_email +"\" \n"

    end

  end

  def self.source_root
     File.dirname(__FILE__)
   end
end


