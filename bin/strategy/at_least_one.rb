require_relative 'deployment_strategy'

class AtLeastOneDeployment < DeploymentStrategy

  def before_group
    @min_size = @lib.group_min_size self.group_name
    max_size = @lib.group_max_size self.group_name
  
    if @lib.group_desired_capacity(self.group_name) == 1
      @lib.update_group_size self.group_name, 2, max_size + 1
    else
      @lib.update_group_size self.group_name, 1, max_size + 1
    end
  end

  def before_instance instance_id
    wait_until_instances_ok
  end

  def after_group
    max_size = @lib.group_max_size self.group_name
    @lib.update_group_size self.group_name, @min_size, max_size - 1
  end

  def instances_ok?
    @lib.count_all_lb_ok_instances(self.group_name) >= 2
  end

end
