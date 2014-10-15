require_relative '../helper/wait_until'

class AtLeastOneDeployment
  include WaitUntil

  def before_group group
    @min_size = group.min_size
    max_size = group.max_size
    new_min_size = 1

    new_min_size = 2 if group.desired_capacity == 1
      
    group.update_size new_min_size, max_size + 1
  end

  def before_instance instance
    wait_until_instances_ok instance.group
  end

  def after_group group
    max_size = group.max_size
    group.update_size @min_size, max_size - 1
  end

  def wait_until_instances_ok group
    wait_until do
      group.health_load_balancer_instances >= 2
    end
  end

end
