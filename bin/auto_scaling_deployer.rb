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
    initial_message
    increase_group_size

    @instances.each_with_index do |instance, i|
      puts "Renew instance #{i + 1}: #{instance.id}"
      renew(instance) if exists_in_load_balancer?(instance)
    end

    decrease_group_size
    puts "Great deploy successfully completed!!"
    space_line
  end

  def exists_in_load_balancer? instance
    @load_balancer.instances.any? do |lb_instance|
      instance.id == lb_instance.id
    end
  end 

  def renew instance  
    puts 'Waiting new instance preparation. This may take some time...'
    wait_until_instances_ok
    instance.terminate(false)
    wait_until_instances_ok
    @quantity_to_renew -= 1
    puts "New instance ok. All right. Missing #{@quantity_to_renew} instances to renew."
    space_line
  end

  def wait_until_instances_ok 
    sleep(30)
    sleep(15) until count_lb_instances == @group.desired_capacity
  end 

  def count_lb_instances
    @load_balancer.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

  def increase_group_size
    update_min_size(@group.min_size + 1)
    update_max_size(@group.max_size + 1)
  end

  def decrease_group_size
    update_min_size(@group.min_size - 1)
    update_max_size(@group.max_size - 1)
  end

  def update_max_size new_max_size
    options = {:max_size => new_max_size}
    @group.update options
  end

  def update_min_size new_min_size
    options = {:min_size => new_min_size}
    @group.update options
  end  

  def initial_message
    STDOUT.sync = true
    space_line
    puts "Initing deploy process..."
    message = "#{@quantity_to_renew} instances to renew: "
    @instances.each do |instance|
      message << "#{instance.id} | "
    end
    puts message
    space_line
  end

  def space_line
    puts
    puts "#################################################################"
    puts
  end  
  
end
