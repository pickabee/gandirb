# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'gandi/version'

Gem::Specification.new do |s|
  s.name = "gandirb"
  s.version = Gandi::VERSION

  s.authors = ["Pickabee"]
  s.email = ""
  s.homepage = "http://github.com/pickabee/gandirb"
  s.summary = %q{Ruby library for using the Gandi XML-RPC API}
  s.description = <<-EOL
  This is a ruby library for using the Gandi XML-RPC API.
  It currently only provides methods for using the domain and mail API, but is extensible enough to add hosting in the future.
  EOL
  
  s.files = ["CHANGELOG", "LICENSE", "README.rdoc", "Rakefile", "lib/gandi.rb", "lib/gandi/base.rb", "lib/gandi/domain.rb", "lib/gandi/domain_modules/contact.rb", "lib/gandi/domain_modules/host.rb", "lib/gandi/domain_modules/mail.rb", "lib/gandi/domain_modules/name_servers.rb", "lib/gandi/domain_modules/operations.rb", "lib/gandi/domain_modules/redirection.rb"]
  s.test_files = ["test/gandi/domain_test.rb", "test/gandi/base_test.rb", "test/gandi_test.rb", "test/test_helper.rb"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--charset=UTF-8", "--title", "Gandirb", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  
  s.add_dependency 'activesupport', '>= 2.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'shoulda', '< 3'
  s.add_development_dependency 'mocha'
end
