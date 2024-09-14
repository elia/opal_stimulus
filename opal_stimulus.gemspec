require_relative "lib/opal_stimulus/version"

Gem::Specification.new do |spec|
  spec.name = "opal_stimulus"
  spec.version = OpalStimulus::VERSION
  spec.authors = ["Elia Schito", "Joseph Schito"]
  spec.email = "elia@schito.me"
  spec.homepage = "https://github.com/opal/opal_stimulus"
  spec.summary =
    "Write Stimulus controllers in Ruby and compile them to JavaScript."
  spec.license = "MIT"

  spec.files = Dir["lib/**/*", "MIT-LICENSE", "README.md"]

  spec.add_dependency "railties", ">= 6.0.0"
  spec.add_dependency "stimulus-rails", ">= 1.0"
  spec.add_dependency "opal", "~> 1.8"
  spec.add_dependency "listen", ">= 3"
end
