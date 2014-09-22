require 'optparse'
require_relative 'auto_scaling_deployer'

options = {}

optparse = OptionParser.new do |opts|
  opts.on('-g', '--group GROUP', 'Auto Scaling Group name') do |group|
    options[:group] = group
  end

  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end
end

begin
  optparse.parse!
  mandatory = [:group]                                         
  missing = mandatory.select{ |param| options[param].nil? }        
  if not missing.empty?                                            
    puts "Missing options: #{missing.join(', ')}"                 
    puts optparse                                                  
    exit                                                           
  end                                                              
rescue OptionParser::InvalidOption, OptionParser::MissingArgument      
  puts $!.to_s                                                           
  puts optparse                                                          
  exit                                                                   
end                                                                      

AutoScalingDeployer.new(options[:group]).do_deploy
