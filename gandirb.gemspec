# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'gandi/version'

Gem::Specification.new do |s|
  s.name = "gandirb"
  s.version = Gandi::VERSION
  s.platform = Gem::Platform::RUBY

  s.authors = ["Pickabee"]
  s.email = ""
  s.homepage = "http://github.com/pickabee/gandirb"
  s.summary = %q{Ruby library for using the Gandi XML-RPC API}
  s.description = <<-EOL
  This is a ruby library for using the Gandi XML-RPC API.
  It currently only provides methods for using the domain and mail API, but is extensible enough to add hosting in the future.
  EOL
  s.rubyforge_project = "gandirb"

  s.date = Date.today.strftime('%Y-%m-%d')

  s.files = Dir["CHANGELOG", "LICENSE", "README.rdoc", "Gemfile", "Rakefile", "gandirb.gemspec", "{lib}/**/*.rb"]
  s.test_files = Dir["{test}/**/*.rb"]
  s.rdoc_options = ["--line-numbers", "--charset=UTF-8", "--title", "Gandirb", "--main", "README.rdoc"]
  s.extra_rdoc_files = %w[CHANGELOG LICENSE]
  s.require_paths = ["lib"]

  s.add_development_dependency 'activesupport', '>= 2.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'shoulda', '< 3'
  s.add_development_dependency 'mocha'
end
