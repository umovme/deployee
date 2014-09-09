require 'aws-sdk'

class AutoScalingDeployer

	def initialize load_balancer, auto_scaling_group
		@load_balancer = AWS::ELB::LoadBalancer.new load_balancer
    @auto_scaling_group = AWS::AutoScaling::Group.new auto_scaling_group
	end	

	def instance_exists_in_load_balancer? instance_id
		@load_balancer.instances.each do |instance|
			return instance_id == instance.id ? true : false
		end	 
	end	

  def desired_capacity
    @auto_scaling_group.desired_capacity
  end 

end
