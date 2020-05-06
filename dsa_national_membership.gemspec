# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'dsa_national_membership'
  gem.version       = '0.3'
  gem.authors       = ['Steve Tuckner']
  gem.email         = ['stevetuckner@gmail.com']
  gem.licenses      = ['MIT']
  gem.description   = %q{A gem to process DSA National membership lists}
  gem.summary       = %q{
                        This helps local chapters in dealing with DSA membership
                        lists sent to the chapter from National.
                      }
  gem.homepage      = 'https://github.com/boberetezeke/dsa-national-membership'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec', '~> 3.9'
end