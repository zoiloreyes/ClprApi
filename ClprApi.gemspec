lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ClprApi/version"

Gem::Specification.new do |spec|
  spec.name = "ClprApi"
  spec.version = ClprApi::VERSION
  spec.authors = ["Marcos Mercedes"]
  spec.email = ["marcos.mercedesn@gmail.com"]

  spec.summary = "Api Implementation for CLPR"
  spec.description = "Api Implementation for CLPR"
  spec.homepage = "https://clasificados.pr"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "active_model_serializers", "0.8.1"
  spec.add_dependency "activesupport"
  spec.add_dependency "addressable"
  spec.add_dependency "faraday", "~> 1.10"
  spec.add_dependency "rsolr"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "httparty"
end
