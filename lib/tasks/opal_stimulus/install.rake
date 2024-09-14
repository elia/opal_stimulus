namespace :opal_stimulus do
  desc "Install StimulsJS with Opal"
  task :install => 'stimulus:install' do
    root = File.expand_path("../../..", __dir__)
    system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{root}/lib/install/install.rb"
  end
end
