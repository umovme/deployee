require_relative 'vendor'

class AWSVendor < Vendor

  def group_instances group_name
    @group = AWS::AutoScaling::Group.new group_name
    @instances = @group.auto_scaling_instances
  end

  def update_group_size group, new_min_size, new_max_size
    options = {:min_size => new_min_size, :max_size => new_max_size}
    group.update options
  end

  def count_ok_lb_instances
    @load_balancer = @group.load_balancers[0]
    @load_balancer.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

end
