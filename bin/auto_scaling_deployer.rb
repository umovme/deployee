require 'aws-sdk'

class AutoScalingDeployer

  def initialize group
    @group = AWS::AutoScaling::Group.new group
    @load_balancer = @group.load_balancers[0]
  end

  def do_deploy
    @group.auto_scaling_instances.each do |instance|
      renew(instance) if exists_in_load_balancer?(instance)
    end
  end

  def exists_in_load_balancer? instance
    @load_balancer.instances.any? do |lb_instance|
      instance.id == lb_instance.id
    end
  end 

  def renew instance
    should_increase_max_size = @group.desired_capacity == @group.max_size
    increase_max_size if should_increase_max_size
      
    puts 'Increasing auto scaling group'
    increase_desired_capacity
    wait_until_instances_ok
    puts instance.terminate(true).description 

    decrease_max_size if should_increase_max_size
  end

  def wait_until_instances_ok 
    puts 'Waiting new instance preparation. This may take some time...'
    sleep(30)
    sleep(15) until count_lb_instances == @group.desired_capacity
    puts 'Instance ok. All right.'
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
    options = {:max_size => @group.max_size + 1}
    @group.update options
  end

  def decrease_max_size
    options = {:max_size => @group.max_size - 1}
    @group.update options
  end
  
end
