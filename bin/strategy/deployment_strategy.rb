require_relative '../lib/aws_lib'

class DeploymentStrategy

  attr_accessor :group_name

  def initialize
    @lib = AWSVendor.new
  end

  def before_group 
  end

  def before_instance instance_id
  end

  def after_instance instance_id
  end

  def after_group 
  end

  def instances_ok? 
  end

  def wait_until_instances_ok 
    puts "Waiting desired instances to be ok"
    sleep(30)
    begin
      sleep(15)
    end until instances_ok? 
  end

end
