require_relative 'deployment_strategy'

class ComputingPreserveDeployment < DeploymentStrategy

  def before_group group_name
    increase_group_size group_name
  end

  def after_group group_name
    decrease_group_size group_name
  end

  def before_instance instance_id
    wait_until_instances_ok
  end

  def after_instance instance_id
    wait_until_instances_ok
  end

  def increase_group_size group_name
    @min_size = @vendor.group_min_size group_name
    max_size = @vendor.group_max_size group_name
  
    @vendor.update_group_size(group_name, min_size + 1, max_size + 1)
  end

  def decrease_group_size group_name
    @min_size = @vendor.group_min_size group_name
    max_size = @vendor.group_max_size group_name

    @vendor.update_group_size(group_name, min_size - 1, max_size - 1)
  end

  def instances_ok? group_name
    @vendor.count_ok_lb_instances == @vendor.group_desired_capacity
  end  

end
