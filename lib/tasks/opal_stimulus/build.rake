namespace :opal_stimulus do
  desc "Build your Opal Stimulus controllers"
  task :build do
    command = "bundle exec opal --output=app/assets/builds/opal.js --watch -c app/opal/main.rb -I app/opal"
    unless system(command)
      raise "opal_stimulus: Command build failed, ensure `#{command}` runs without errors"
    end
  end
end

unless ENV["SKIP_JS_BUILD"]
  if Rake::Task.task_defined?("assets:precompile")
    Rake::Task["assets:precompile"].enhance(["opal_stimulus:build"])
  end

  if Rake::Task.task_defined?("test:prepare")
    Rake::Task["test:prepare"].enhance(["opal_stimulus:build"])
  elsif Rake::Task.task_defined?("spec:prepare")
    Rake::Task["spec:prepare"].enhance(["opal_stimulus:build"])
  elsif Rake::Task.task_defined?("db:test:prepare")
    Rake::Task["db:test:prepare"].enhance(["opal_stimulus:build"])
  end
end
