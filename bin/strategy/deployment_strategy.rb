require_relative '../vendor/aws_vendor'

class DeploymentStrategy

  def initialize
    @vendor = AWSVendor.new
  end

  def before_group scale_group
  end

  def before_instance instance
  end

  def after_instance instance
  end

  def after_group scale_group
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
