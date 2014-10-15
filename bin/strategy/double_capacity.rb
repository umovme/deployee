
class DoubleCapacityDeployment
  include WaitUntil

  def before_group group
    @min_size = group.min_size
    group.update_size(group.instances.size * 2, group.max_size * 2)
    wait_until_instances_ok group
    group.update_size(@min_size, group.max_size / 2)
  end

  def wait_until_instances_ok group
    wait_until do
      group.health_load_balancer_instances == group.desired_capacity
    end
  end

end
