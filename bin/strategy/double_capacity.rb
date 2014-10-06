require_relative 'deployment_strategy'

class DoubleCapacityDeployment < DeploymentStrategy

  def before_group group
    @min_size = group.min_size
    instances = group.auto_scaling_instances
    
    @vendor.update_group_size(group, instances.size * 2, group.max_size * 2)
    wait_until_instances_ok
    @vendor.update_group_size(group, @min_size, group.max_size / 2)
  end

  def instances_ok?
    @vendor.count_ok_lb_instances == @group.desired_capacity
  end  

end
