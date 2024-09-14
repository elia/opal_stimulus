require 'json'

say "Compile into app/assets/builds"
empty_directory "app/assets/builds"
keep_file "app/assets/builds"

if (sprockets_manifest_path = Rails.root.join("app/assets/config/manifest.js")).exist?
  append_to_file sprockets_manifest_path, %(//= link_tree ../builds\n)
end

if Rails.root.join(".gitignore").exist?
  append_to_file(".gitignore", %(\n/app/assets/builds/*\n!/app/assets/builds/.keep\n))
  append_to_file(".gitignore", %(\n/node_modules\n))
end

if Rails.root.join("config/importmap.rb").exist?
  append_to_file("config/importmap.rb", %(\npin_all_from "app/opal", under: "opal"\n))
end

if (app_layout_path = Rails.root.join("app/views/layouts/application.html.erb")).exist?
  say "Add JavaScript include tag in application layout"
  insert_into_file app_layout_path.to_s,
    %(\n    <%= javascript_include_tag "opal", "data-turbo-track": "reload", type: "module" %>), before: /\s*<\/head>/
else
  say "Default application.html.erb is missing!", :red
  say %(        Add <%= javascript_include_tag "opal", "data-turbo-track": "reload", type: "module" %> within the <head> tag in your custom layout.)
end

say "Create default entrypoint in app/javascript/application.js"
append_to_file Rails.root.join("app/javascript/application.js"), <<~JS
  import { Controller } from '@hotwired/stimulus'
  window.Stimulus.Controller = Controller
JS

append_to_file Rails.root.join("app/javascript/controllers/opal_controller.js"), <<~JS
  import { Controller } from "@hotwired/stimulus"
  class OpalStimulusController extends Controller {}
  window.OpalStimulusController = OpalStimulusController
JS

copy_file "#{__dir__}/opal/main.rb", "app/opal/main.rb"
copy_file "#{__dir__}/opal/stimulus_controller.rb", "app/opal/stimulus_controller.rb"
empty_directory "app/opal/controllers"

say "Add bin/dev to start foreman"
copy_file "#{__dir__}/dev", "bin/dev"
chmod "bin/dev", 0755, verbose: false

if Rails.root.join("Procfile.dev").exist?
  append_to_file "Procfile.dev", "js: bun run build --watch\n"
else
  say "Add default Procfile.dev"
  copy_file "#{__dir__}/Procfile.dev", "Procfile.dev"

  say "Ensure foreman is installed"
  run "gem install foreman"
end
