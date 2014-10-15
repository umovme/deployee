require_relative '../lib/scale_group'

class DeployRunner

  def initialize strategy
    @strategy = strategy
  end

  def run group_name
    group = ScaleGroup.new group_name
    instances = group.instances
    
    @strategy.before_group(group) if @strategy.respond_to? :before_group
    deploy group, instances
    @strategy.after_group group  if @strategy.respond_to? :after_group
  end

  def deploy group, instances
    instances.each_with_index do |instance, index|
      puts "Starting deployment #{index + 1}. Instance #{instance.id}"
      deploy_instance instance
      puts "Finished deployment #{index + 1}. Instance #{instance.id}"
    end
  end

  def deploy_instance instance
    if instance.exists?
      @strategy.before_instance instance if @strategy.respond_to? :before_instance
      renew instance
      @strategy.after_instance instance  if @strategy.respond_to? :after_instance
    else 
      puts "Instance out. Ignored during renew"
    end
  end

  def renew instance
    puts "Terminating instance #{instance.id}"
    instance.terminate
    puts "Instance #{instance.id} sucessfully terminated"
  end

end
