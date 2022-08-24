require_relative 'lib/hostedhooks/version'

Gem::Specification.new do |spec|
  spec.name          = "hostedhooks"
  spec.version       = HostedHooks::VERSION
  spec.authors       = ["Ian Grabill"]
  spec.email         = ["ian@hostedhooks.com"]

  spec.summary       = %q{A ruby library for the HostedHooks API}
  spec.homepage      = "https://github.com/HostedHooks/hostedhooks-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency "httparty"
end
