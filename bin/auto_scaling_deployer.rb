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

  def validate_lb_instances_quantity 
    puts 'Waiting new instance preparation...'
    count = 0
    
    while count < 60 do 
      lb_instances_quantity = @load_balancer.instances.count
      desired_capacity = @auto_scaling_group.desired_capacity

      puts "Instances in lb: #{lb_instances_quantity}"
      puts "Desired instances in lb: #{desired_capacity}"

      if lb_instances_quantity == desired_capacity
        puts 'Instances quantity is ok on lb'
        return
      else
        count += 1
        puts 'Waiting for instances quantity ok in lb'   
        puts "Times: #{count}"
        sleep(15)
      end  
    end

    puts 'The instances quantity this is not correct. Contact support.'
    exit 1
  end  

end
