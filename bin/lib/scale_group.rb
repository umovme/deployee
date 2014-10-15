require 'aws-sdk'
require_relative 'scale_instance'
require_relative 'scale_loadbalancer'

class ScaleGroup

  def initialize group_name
    @delegate = AWS::AutoScaling::Group.new group_name
  end

  def instances
    @delegate.auto_scaling_instances.map do |instance|
      ScaleInstance.new instance.id, self
    end
  end

  def min_size
    @delegate.min_size
  end  

  def max_size
    @delegate.max_size
  end  

  def desired_capacity 
    @delegate.desired_capacity
  end

  def update_size new_min_size, new_max_size
    options = {:min_size => new_min_size, :max_size => new_max_size}
    @delegate.update options
  end

  def health_load_balancer_instances
    load_balancers.map{|lb| lb.healthy_instances}.reduce{|a, b| a + b}
  end

  def load_balancers
    @delegate.load_balancer_names.map do |lb_name|
      ScaleLoadBalancer.new lb_name
    end
  end

end
