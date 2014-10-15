Gem::Specification.new do |s|
  s.name		    = "deployee"
  s.version      	= "0.0.2"
  s.description		= "A tool to simplify deployments using AWS auto scaling engine."
  s.summary   		= ""
  s.author     		= "Eduardo Bohrer, Gabriel Prestes, Guilherme Elias, Robson Bittencourt"
  s.files           = Dir["{lib/**/*,README.md,*.gemspec}"]
  s.executables	    = "deployee"
  s.add_runtime_dependency 'aws-sdk', '~> 1.52', '>= 1.52.0' 
end
