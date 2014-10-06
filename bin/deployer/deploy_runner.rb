class DeployRunner

  def initialize(strategy)
    @strategy = strategy
    @vendor = AWSVendor.new
  end

  def run group_name
    @strategy.before_group group_name
    deploy group_name
    @strategy.after_group group_name
  end

  def deploy group_name
    instances = @vendor.group_instances group_name 
    instances.each_with_index do |instance, i|
      puts "Starting deployment #{i + 1}. Instance #{instance.id}"
      deploy_instance instance
      puts "Finished deployment #{i + 1}. Instance #{instance.id}"
    end
  end

  def deploy_instance instance
    if instance.exists?
      @strategy.before_instance instance.id
      renew instance
      @strategy.after_instance instance.id
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

