require_relative 'deployment_strategy'

class DoubleCapacityDeployment < DeploymentStrategy

  def before_group
    @min_size = @lib.group_min_size self.group_name
    group_size = @lib.group_size self.group_name

    @lib.update_group_size(self.group_name, group_size * 2, @lib.group_max_size(self.group_name) * 2)
    wait_until_instances_ok self.group_name
    @lib.update_group_size(self.group_name, @min_size, @lib.group_max_size(self.group_name) / 2)
  end

  def instances_ok?
    @lib.count_all_lb_ok_instances(self.group_name) == @lib.group_desired_capacity(self.group_name) 
  end  

end
