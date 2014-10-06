require 'aws-sdk'

class AWSVendor

  def group_min_size group_name
    AWS::AutoScaling::Group.new(group_name).min_size
  end  

  def group_max_size group_name
    AWS::AutoScaling::Group.new(group_name).max_size
  end  

  def group_desired_capacity group_name
    AWS::AutoScaling::Group.new(group_name).desired_capacity
  end
 
  def group_instances group_name
    @group = AWS::AutoScaling::Group.new group_name
    @instances = @group.auto_scaling_instances
  end

  def update_group_size group_name, new_min_size, new_max_size
    options = {:min_size => new_min_size, :max_size => new_max_size}
    group = get_group group_name
    group.update options
  end

  def count_all_lb_ok_instances
    @load_balancer = @group.load_balancers[0]
    @load_balancer.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

end
