require 'aws-sdk'

class DeployRunner

  def initialize(strategy)
    @strategy = strategy
    @vendor = AWSVendor.new
  end

  def run group_name
    group = AWS::AutoScaling::Group.new group_name
    @strategy.before_group group
    deploy group
    @strategy.after_group group
  end

  def deploy group
    instances = @vendor.group_instance group 
    instances.each_with_index do |instance, i|
      puts "Starting deployment #{i + 1}. Instance #{instance.id}"
      deploy_instance instance
      puts "Finished deployment #{i + 1}. Instance #{instance.id}"
    end
  end

  def deploy_instance instance
    if instance.exists?
      @strategy.before_instance instance
      renew instance
      @strategy.after_instance instance
    else
      puts "Instance out. Ignored during renew"
    end
  end

  def renew instance  
    puts "Terminating instance #{instance.id}"
    instance.terminate(false)
    puts "Instance #{instance.id} sucessfully terminated"
  end

end

