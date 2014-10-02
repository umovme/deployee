require_relative '../engine'

class AtLeastOneDeployment < DeploymentEngine

  def before_group group
    @min_size = group.min_size
    if group.desired_capacity == 1
      update_group_size group, 2, group.max_size + 1
    else
      update_group_size group, 1, group.max_size + 1
    end
  end

  def before_instance instance
    wait_until_instances_ok
  end

  def after_group group
    update_group_size group, @min_size, group.max_size - 1
  end

  def update_group_size group, new_min_size, new_max_size
    options = {:min_size => new_min_size, :max_size => new_max_size}
    group.update options
  end

  def wait_until_instances_ok 
    puts "Waiting desired instances to be ok"
    sleep(30)
    begin
      sleep(15)
    end until count_ok_lb_instances >= 2
  end 

  def count_ok_lb_instances
    @load_balancer = @group.load_balancers[0]
    @load_balancer.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

end
