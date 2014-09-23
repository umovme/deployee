require 'aws-sdk'

class AutoScalingDeployer

  def initialize group
    @group = AWS::AutoScaling::Group.new group
    @load_balancer = @group.load_balancers[0]
    @instances = auto_scaling_instances
    @quantity_to_renew = @instances.size
  end

  def auto_scaling_instances
    auto_scaling_instances = []
    @load_balancer.instances.each do |instance|
      auto_scaling_instances << AWS::AutoScaling.new.instances[instance.id]
    end
    auto_scaling_instances
  end  

  def do_deploy
    show_initial_message
    @instances.each_with_index do |instance, i|
      puts "Renew instance #{i + 1}: #{instance.id}"
      renew(instance) if exists_in_load_balancer?(instance)
    end

    puts "Great deploy successfully completed!!"
  end

  def exists_in_load_balancer? instance
    @load_balancer.instances.any? do |lb_instance|
      instance.id == lb_instance.id
    end
  end 

  def renew instance
    should_update_max_size = @group.desired_capacity == @group.max_size
    increase_max_size if should_update_max_size
      
    increase_desired_capacity
    wait_until_instances_ok
    instance.terminate(true) 

    decrease_max_size if should_update_max_size
  end

  def wait_until_instances_ok 
    puts 'Waiting new instance preparation. This may take some time...'
    sleep(30)
    sleep(15) until count_lb_instances == @group.desired_capacity
    @quantity_to_renew -= 1
    puts "New instance ok. All right. Missing #{@quantity_to_renew} instances to renew."
    puts
  end 

  def count_lb_instances
    @load_balancer.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

  def increase_desired_capacity
    @group.set_desired_capacity @group.desired_capacity + 1
  end

  def increase_max_size
    update_max_size(@group.max_size + 1)
  end

  def decrease_max_size
    update_max_size(@group.max_size - 1)
  end

  def update_max_size new_max_size
    options = {:max_size => new_max_size}
    @group.update options
  end  

  def show_initial_message
    puts
    puts "Initing deploy process..."
    message = "#{@quantity_to_renew} instances to renew: "
    @instances.each do |instance|
      message << "#{instance.id} | "
    end
    puts message  
  end

end
