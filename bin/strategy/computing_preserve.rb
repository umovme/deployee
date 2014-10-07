require_relative 'deployment_strategy'

class ComputingPreserveDeployment < DeploymentStrategy

  def before_group 
    increase_group_size
  end

  def after_group 
    decrease_group_size
  end

  def before_instance instance_id
    wait_until_instances_ok
  end

  def after_instance instance_id
    wait_until_instances_ok
  end

  def increase_group_size 
    min_size = @lib.group_min_size self.group_name
    max_size = @lib.group_max_size self.group_name
  
    @lib.update_group_size(self.group_name, min_size + 1, max_size + 1)
  end

  def decrease_group_size 
    min_size = @lib.group_min_size self.group_name
    max_size = @lib.group_max_size self.group_name

    @lib.update_group_size(self.group_name, min_size - 1, max_size - 1)
  end

  def instances_ok? 
    @lib.count_all_lb_ok_instances(self.group_name) == @lib.group_desired_capacity(self.group_name) 
  end  

end
