require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :spec

desc 'Run specs for the authorize_me plugin.'
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w[--backtrace]
end

desc 'Generate documentation for the authorize_me plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('lib/**/*.rb', 'MIT-LICENSE', 'README.rdoc')

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'AuthorizeMe'
  rdoc.options << '--line-numbers' << '--inline-source'
end
