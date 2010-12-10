require File.join(File.dirname(__FILE__), 'lib', 'authorize_me', 'version')
require 'rake'

Gem::Specification.new do |s|
  s.name = "authorize_me"
  s.version = AuthorizeMe::Version
  s.authors = ["Adam McCrea", "John Andrews"]
  s.description = ""
  s.summary = ""
  s.date = "2010-12-10"
  s.email = "adam@edgecase.com"
  s.homepage = "http://github.com/edgecase/authorize_me"

  s.extra_rdoc_files = %w[ MIT-LICENSE README.rdoc ]

  s.files = FileList['lib/**/*.rb', 'rails/**/*.rb'].to_a + %w[ 
    MIT-LICENSE
    README.rdoc
  ]

  s.test_files = FileList['spec/**'].to_a
end
