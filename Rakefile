require 'bundler/setup'
require 'rake'
require 'bundler/gem_tasks'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Gandirb"
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README*', 'CHANGELOG', 'LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options << "--line-numbers"
  rdoc.options << "--charset=UTF-8"
end
