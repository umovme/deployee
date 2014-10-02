require_relative '../engine'

class DoubleCapacityDeployment < DeploymentEngine

  def before_group group
    @min_size = group.min_size
    instances = group.auto_scaling_instances
    update_group_size(group, instances.size * 2, group.max_size * 2)
    wait_until_instances_ok
    update_group_size(group, @min_size, group.max_size / 2)
  end

  def update_group_size group, new_min_size, new_max_size
    options = {:min_size => new_min_size, :max_size => new_max_size}
    group.update options
  end

  def wait_until_instances_ok 
    sleep(30)
    puts "Waiting desired instances to be ok"
    begin
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
