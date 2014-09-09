require 'aws-sdk'

class AutoScalingDeployer

	def initialize load_balancer
		@load_balancer = AWS::ELB::LoadBalancer.new load_balancer
	end	

	def instance_exists_in_load_balancer? instance_id
		@load_balancer.instances.each do |instance|
			return instance_id == instance.id ? true : false
		end	 
	end	

end

puts AutoScalingDeployer.new('us-umov-vpc-chart').instance_exists_in_load_balancer? 'i-53d55b35'