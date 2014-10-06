require_relative 'deployment_strategy'

class DoubleCapacityDeployment < DeploymentStrategy

  def before_group group_name
    @min_size = @vendor.group_min_size group_instances
    max_size = @vendor.group_max_size group_name 
    instances = @vendor.group_instances group_instances  
    
    @vendor.update_group_size(group_name, instances.size * 2, max_size * 2)
    wait_until_instances_ok
    @vendor.update_group_size(group_name, @min_size, max_size / 2)
  end

  def instances_ok? group_name
    @vendor.count_ok_lb_instances == @vendor.group_desired_capacity(group_name) 
  end  

end
