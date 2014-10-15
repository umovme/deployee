
class ComputingPreserveDeployment
  include WaitUntil
  
  def before_group group
    group.update_size(group.min_size + 1, group.max_size + 1)
  end

  def before_instance instance
    wait_until_instances_ok instance.group
  end

  def after_instance instance
    wait_until_instances_ok instance.group
  end

  def after_group group
    group.update_size(group.min_size - 1, group.max_size - 1)
  end

  def wait_until_instances_ok group
    wait_until do
      group.health_load_balancer_instances == group.desired_capacity
    end
  end

end
