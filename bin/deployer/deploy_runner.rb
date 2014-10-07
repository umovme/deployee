class DeployRunner

  def initialize(strategy)
    @strategy = strategy
    @lib = AWSVendor.new
  end

  def run group_name
    @strategy.group_name = group_name
    @strategy.before_group
    deploy group_name
    @strategy.after_group
  end

  def deploy group_name
    instances = @lib.group_instances group_name 
    instances.each_with_index do |instance_id, i|
      puts "Starting deployment #{i + 1}. Instance #{instance_id}"
      deploy_instance instance_id
      puts "Finished deployment #{i + 1}. Instance #{instance_id}"
    end
  end

  def deploy_instance instance_id
    if @lib.instance_exists? instance_id
      @strategy.before_instance instance_id
      renew instance_id
      @strategy.after_instance instance_id
    else
      puts "Instance out. Ignored during renew"
    end
  end

  def renew instance_id  
    puts "Terminating instance #{instance_id}"
    @lib.terminate_instance(instance_id)
    puts "Instance #{instance_id} sucessfully terminated"
  end

end

