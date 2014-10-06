require_relative 'deployment_strategy'

class ComputingPreserveDeployment < DeploymentStrategy

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
    @vendor.update_group_size(group, group.min_size + 1, group.max_size + 1)
  end

  def decrease_group_size group
    @vendor.update_group_size(group, group.min_size - 1, group.max_size - 1)
  end

  def instances_ok?
    @vendor.count_ok_lb_instances == @group.desired_capacity
  end  

end
