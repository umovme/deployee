require 'aws-sdk'

class DeploymentEngine

  def initialize group
    @group = AWS::AutoScaling::Group.new group
    @instances = @group.auto_scaling_instances
  end

  def deploy
    puts "Starting deployment. #{@instances.size} to renew"
    before_group @group
    @instances.each_with_index do |instance, i|
      puts "Starting deployment #{i}. Instance #{instance.id}"
      deploy_instance instance
      puts "Finished deployment #{i}. Instance #{instance.id}"
    end
    after_group @group
    puts "Deployment sucessfully finished"
  end

  def deploy_instance instance
    if instance.exists?
      before_instance instance
      renew instance
      after_instance instance
    else
      puts "Instance out. Ignored during renew"
    end
  end

  def renew instance  
    puts "Terminating instance #{instance.id}"
    instance.terminate(false)
    puts "Instance #{instance.id} sucessfully terminated"
  end

  def before_group scale_group
  end

  def before_instance instance
  end

  def after_instance instance
  end

  def after_group scale_group
  end

  def count_ok_instances
  end  
  
end
