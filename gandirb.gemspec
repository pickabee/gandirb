# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gandirb}
  s.version = "1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pickabee"]
  s.date = %q{2010-04-30}
  s.description = <<-EOL
  This is a ruby library for using Gandi XML-RPC API.
  It should only support the domain and mail API, but may be extensible enough to add hosting in the future.
  EOL
  s.summary = %q{Ruby library for using Gandi XML-RPC API}
  s.email = %q{}
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README", "lib/gandi.rb", "lib/gandi/base.rb", "lib/gandi/domain.rb", "lib/gandi/domain_modules/contact.rb", "lib/gandi/domain_modules/host.rb", "lib/gandi/domain_modules/mail.rb", "lib/gandi/domain_modules/name_servers.rb", "lib/gandi/domain_modules/operations.rb", "lib/gandi/domain_modules/redirection.rb"]
  s.files = ["CHANGELOG", "LICENSE", "README", "Rakefile", "lib/gandi.rb", "lib/gandi/base.rb", "lib/gandi/domain.rb", "lib/gandi/domain_modules/contact.rb", "lib/gandi/domain_modules/host.rb", "lib/gandi/domain_modules/mail.rb", "lib/gandi/domain_modules/name_servers.rb", "lib/gandi/domain_modules/operations.rb", "lib/gandi/domain_modules/redirection.rb", "rdoc/classes/Gandi.html", "rdoc/classes/Gandi/Base.html", "rdoc/classes/Gandi/DataError.html", "rdoc/classes/Gandi/Domain.html", "rdoc/classes/Gandi/DomainModules.html", "rdoc/classes/Gandi/DomainModules/Contact.html", "rdoc/classes/Gandi/DomainModules/Host.html", "rdoc/classes/Gandi/DomainModules/NameServers.html", "rdoc/classes/Gandi/DomainModules/Operations.html", "rdoc/classes/Gandi/DomainModules/Redirection.html", "rdoc/classes/Gandi/ServerError.html", "rdoc/created.rid", "rdoc/files/README.html", "rdoc/files/lib/gandi/base_rb.html", "rdoc/files/lib/gandi/domain_modules/contact_rb.html", "rdoc/files/lib/gandi/domain_modules/host_rb.html", "rdoc/files/lib/gandi/domain_modules/name_servers_rb.html", "rdoc/files/lib/gandi/domain_modules/operations_rb.html", "rdoc/files/lib/gandi/domain_modules/redirection_rb.html", "rdoc/files/lib/gandi/domain_rb.html", "rdoc/files/lib/gandi_rb.html", "rdoc/fr_class_index.html", "rdoc/fr_file_index.html", "rdoc/fr_method_index.html", "rdoc/index.html", "rdoc/rdoc-style.css", "test/gandi/base_test.rb", "test/gandi/domain_test.rb", "test/gandi_test.rb", "test/test_helper.rb", "gandirb.gemspec"]
  s.homepage = %q{http://github.com/pickabee/gandirb}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Gandirb", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gandirb}
  s.rubygems_version = %q{1.3.6}
  s.test_files = ["test/gandi/domain_test.rb", "test/gandi/base_test.rb", "test/gandi_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
