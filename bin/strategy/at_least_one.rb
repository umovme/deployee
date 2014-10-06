require_relative 'deployment_strategy'

class AtLeastOneDeployment < DeploymentStrategy

  def before_group group
    @min_size = group.min_size
    if group.desired_capacity == 1
      @vendor.update_group_size group, 2, group.max_size + 1
    else
      @vendor.update_group_size group, 1, group.max_size + 1
    end
  end

  def before_instance instance
    wait_until_instances_ok
  end

  def after_group group
    @vendor.update_group_size group, @min_size, group.max_size - 1
  end

  def instances_ok?
    @vendor.count_ok_lb_instances >= 2
  end

end
