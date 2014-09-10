require 'aws-sdk'

class AutoScalingDeployer

	def initialize auto_scaling_group
		@auto_scaling_group = AWS::AutoScaling::Group.new auto_scaling_group
    @load_balancer = @auto_scaling_group.load_balancers[0]
	end	

	def instance_exists_in_load_balancer? instance_id
		@load_balancer.instances.each do |instance|
			return instance_id == instance.id ? true : false
		end	 
	end	

  def get_ok_intances_in_load_balancer
    instances_ok = 0
    @load_balancer.instances.each do |instance|
      if instance.status.to_s == 'running'
        instances_ok += 1
      end  
    end 
    return instances_ok
  end  

  def validate_lb_instances_quantity 
    puts 'Waiting new instance preparation. This may take some time...'
    count = 0
    
    while count < 60 do 
      lb_instances_quantity = get_ok_intances_in_load_balancer
      desired_capacity = @auto_scaling_group.desired_capacity
  
      if lb_instances_quantity == desired_capacity
        puts 'Instance ok. All right.'
        return
      else
        count += 1
        sleep(15)
      end  
    end

    puts 'Instance not initialized. Contact support.'
    exit 1
  end  

end
