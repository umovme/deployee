require 'aws-sdk'

class AWSVendor

  def get_group group_name
    AWS::AutoScaling::Group.new group_name
  end 

  def group_size group_name
    get_group(group_name).auto_scaling_instances.size
  end  

  def group_min_size group_name
    get_group(group_name).min_size
  end  

  def group_max_size group_name
    get_group(group_name).max_size
  end  

  def group_desired_capacity group_name
    get_group(group_name).desired_capacity
  end
 
  def group_instances group_name
    group = get_group(group_name)
    instances = []  
    group.auto_scaling_instances.each do |instance|
      instances.push(instance.id)
    end
    return instances  
  end

  def update_group_size group_name, new_min_size, new_max_size
    options = {:min_size => new_min_size, :max_size => new_max_size}
    group = get_group group_name
    group.update options
  end

  #TODO - Refatorar para pegar todos load balancers
  def count_all_lb_ok_instances group_name
    load_balancer = get_group(group_name).load_balancers[0]
    load_balancer.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

  def get_instance instance_id
    AWS::EC2::Instance.new instance_id
  end

  def instance_exists? instance_id
    get_instance(instance_id).exists?
  end
  
  def terminate_instance instance_id
    get_instance(instance_id).terminate
  end

end
