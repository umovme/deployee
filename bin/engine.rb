require 'aws-sdk'

class DeploymentEngine

  def initialize group
    @group = AWS::AutoScaling::Group.new group
    @load_balancer = @group.load_balancers[0]
    @instances = auto_scaling_instances
  end

  def auto_scaling_instances
    @load_balancer.instances.map do |instance|
      AWS::AutoScaling.new.instances[instance.id]
    end
  end 

  def deploy
    puts "Starting deployment. #{@instances.size} to renew"

    before_group @group

    @instances.each_with_index do |instance, i|
      puts "Starting deployment #{i}. Instance #{instance.id}"
      deploy_instance instance
      puts "Finished deployment #{i}. Instance #{instance.id}"
    end

    after_group @group

    puts "Deployment sucessfully finished"
  end

  def deploy_instance instance
    if exists_in_load_balancer? instance
      before_instance instance
      renew instance
      after_instance instance
    else
      puts "Instance out of loadbalancer. Ignored during renew"
    end
  end

  def exists_in_load_balancer? instance
    @load_balancer.instances.any? do |lb_instance|
      instance.id == lb_instance.id
    end
  end 

  def renew instance  
    wait_until_instances_ok
    puts "Terminating instance #{instance.id}"
    instance.terminate(false)
    puts "Instance #{instance.id} sucessfully terminated"
    wait_until_instances_ok
  end

  def wait_until_instances_ok 
    sleep(30)
    begin
      puts "Waiting desired instances to be ok"
      sleep(15)
    end until count_lb_instances == @group.desired_capacity
  end 

  def count_lb_instances
    @load_balancer.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

  def before_group scale_group
  end

  def before_instance instance
  end

  def after_instance instance
  end

  def after_group scale_group
  end
  
end


class ComputingPreserveDeployment << DeploymentEngine

  def before_group scale_group
    increase_group_size
  end

  def after_group scale_group
    decrease_group_size
  end

  def increase_group_size group
    update_group_size(group, group.min_size + 1, group.max_size + 1)
  end

  def decrease_group_size group
    update_group_size(group, group.min_size - 1, group.max_size - 1)
  end

  def update_group_size group, new_min_size, new_max_size
    group.update {:min_size => new_min_size, :max_size => new_max_size}
  end

end
