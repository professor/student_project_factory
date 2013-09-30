#Goldberg configuration
Project.configure do |config|
#    config.ruby = '1.9.2-p180'
    config.use_bundle_exec = true                             # Run 'bundle exec rake', recommended for Rails projects
    config.rake_task = 'continuous_integration'
    config.environment_variables = {'RAILS_ENV' => 'test'}
    config.bundler_options = '--without development'

    from = "build.machine@sv.cmu.edu"

  config.on_build_completion do |build,notification,previous_build_status|
    puts "################ call back in goldberg_config.rb on_build_completion"
    # notification.from(from).to(email).with_subject("Build for #{build.project.name} #{build.status} (Build number: #{build.number})").send
    # sending mail
  end

  config.on_build_success do |build,notification|
    # code to deploy on staging
    puts "################ call back in goldber_config.rb"
    #  notification.from(from).to(email).with_subject("Build for #{build.project.name} #{build.status} (Build number: #{build.number})").send
  end

  config.on_build_failure do |build,notification|
    # post to IRC channel & send mail
    puts "################ call back in goldber_config.rb"
    notification.from(from).to(email).with_subject("Build for #{build.project.name} #{build.status} (Build number: #{build.number})").send
  end

  config.on_build_fixed do |build,notification|
    puts "################ call back in goldber_config.rb"
    notification.from(from).to(email).with_subject("Build for #{build.project.name} #{build.status} (Build number: #{build.number})").send
    # post to IRC channel & deploy on staging
  end

end

