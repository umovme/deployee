require_relative 'deployment_strategy'

class AtLeastOneDeployment < DeploymentStrategy

  def before_group group_name
    @min_size = @vendor.group_min_size group_name
    max_size = @vendor.group_max_size group_name
  
    if @vendor.group_desired_capacity == 1
      @vendor.update_group_size group_name, 2, max_size + 1
    else
      @vendor.update_group_size group_name, 1, max_size + 1
    end
  end

  def before_instance instance
    wait_until_instances_ok
  end

  def after_group group_name
    max_size = @vendor.group_max_size group_name
    @vendor.update_group_size group_name, @min_size, max_size - 1
  end

  def instances_ok? group_name
    @vendor.count_all_lb_ok_instances >= 2
  end

end
