
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simple_event_sourcing/version"

Gem::Specification.new do |spec|
  spec.name          = "simple_event_sourcing"
  spec.version       = SimpleEventSourcing::VERSION
  spec.authors       = ["Manuel López Torrent"]
  spec.email         = ["malotor@gmail.com"]

  spec.summary       = %q{This gem provides a simple way for add events sourcing related behaviour to your models class}
  spec.description   = %q{This gem provides a simple way for add events sourcing related behaviour to your models class}
  spec.homepage      = "https://github.com/malotor/ruby_event_sourcing"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  # Development dependencies
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  #spec.add_development_dependency "facets"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "timecop"

  # Runtime dependencies
  spec.add_runtime_dependency "redis"
end
