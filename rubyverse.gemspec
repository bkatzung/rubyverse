Gem::Specification.new do |s|
  s.name         = "rubyverse"
  s.version      = "0.0.1"
  s.date         = "2014-04-13"
  s.authors      = ["Brian Katzung"]
  s.email        = ["briank@kappacs.com"]
  s.homepage     = "http://rubygems.org/gems/rubyverse"
  s.summary      = "Semi-private method spaces in parallel Rubyverses"
  s.description  = "Parallel Ruby universes (\"Rubyverses\") - a proposed interface for parallel, \"semi-private\" method or method-and-data spaces via \"closely associated\" objects."
  s.license      = "Public Domain"
 
  s.files        = Dir.glob("lib/**/*") +
		   %w{rubyverse.gemspec HISTORY.txt .yardopts}
  s.test_files   = Dir.glob("test/**/*.rb")
  s.require_path = 'lib'
end
