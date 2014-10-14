require_relative 'deployment_strategy'

class ComputingPreserveDeployment < DeploymentStrategy

  def before_group group
    group.update_size(group.min_size + 1, group.max_size + 1)
  end

  def before_instance instance
    wait_until_instances_ok instance
  end

  def after_instance instance
    wait_until_instances_ok instance
  end

  def after_group group
    group.update_size(group.min_size - 1, group.max_size - 1)
  end

  def wait_until_instances_ok instance
    group = instance.group
    wait_until do
      group.health_load_balancer_instances == group.desired_capacity
    end
  end

end
