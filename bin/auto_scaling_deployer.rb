require 'aws-sdk'

class AutoScalingDeployer

  def initialize auto_scaling_group
    @auto_scaling_group = AWS::AutoScaling::Group.new auto_scaling_group
    @load_balancer = @auto_scaling_group.load_balancers[0]
  end	

  def deploy_with_one_instance_on_lb
    instance = @auto_scaling_group.auto_scaling_instances[0]
    
    puts 'Increasing auto scaling group'
    @auto_scaling_group.set_desired_capacity(2)
    validate_lb_instances_quantity
    
    puts 'Terminating old instance'
    status = instance.terminate(false)
    puts status.description    
  end  

  def deploy_with_many_instances_on_lb
    instances = @auto_scaling_group.auto_scaling_instances
    
    instances.each do |instance|
      puts instance.id
      if instance_exists_in_load_balancer? instance
        status = instance.terminate(false)
        puts status.description 
        validate_lb_instances_quantity
      end  
    end
      
  end  

  def instance_exists_in_load_balancer? instance
    puts instance.id
    @load_balancer.instances.each do |lb_instance|
      puts lb_instance.id
      return instance.id == lb_instance.id ? true : false
    end	 
  end	

  def quantity_ok_intances_in_load_balancer
    ok_instances = 0
    @load_balancer.instances.health.each do |health|
      if health[:state] == 'InService'
        ok_instances += 1
      end  
    end
    return ok_instances
  end  

  def validate_lb_instances_quantity 
    puts 'Waiting new instance preparation. This may take some time...'
    sleep(30)
    count = 0
    lb_status = false

    while count < 90 do 
      lb_instances_quantity = quantity_ok_intances_in_load_balancer
      desired_capacity = @auto_scaling_group.desired_capacity
      puts "Desired: #{desired_capacity}"
      if lb_instances_quantity == desired_capacity
        puts 'Instance ok. All right.'
        lb_status = true
        break
      else
        count += 1
        sleep(15)
      end  
    end

    if !lb_status
      puts 'Instance not initialized. Contact support.'
      exit 1
    end
      
  end  

end

AutoScalingDeployer.new('test-for-deployer').deploy_with_many_instances_on_lb
