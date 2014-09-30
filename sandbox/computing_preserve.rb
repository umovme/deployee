require_relative 'engine'

class ComputingPreserveDeployment < DeploymentEngine

  def before_group scale_group
    increase_group_size scale_group
  end

  def after_group scale_group
    decrease_group_size scale_group
  end

  def before_instance instance
    wait_until_instances_ok
  end

  def after_instance instance
    wait_until_instances_ok
  end

  def increase_group_size group
    update_group_size(group, group.min_size + 1, group.max_size + 1)
  end

  def decrease_group_size group
    update_group_size(group, group.min_size - 1, group.max_size - 1)
  end

  def update_group_size group, new_min_size, new_max_size
    options = {:min_size => new_min_size, :max_size => new_max_size}
    group.update options
  end

  def wait_until_instances_ok 
    sleep(30)
    begin
      puts "Waiting desired instances to be ok"
      sleep(15)
    end until count_ok_lb_instances == @group.desired_capacity
  end 

  def count_ok_lb_instances
    @load_balancer = @group.load_balancers[0]
    @load_balancer.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

end
