class AWSVendotImpl

  def start_instance instance

  end

  def group_instances group_name

  end
end

class DeployRunner

  def initilzize(strategy)
    @strategy = strategy
    @vendor = DeployVendor.new
  end

  def run group
    @strategy.before_group(@vendor) if @strategy.

    @strategy.before_instance
    @strategy.after_instance
    @strategy.after_group
  end

end


deploy = Deploy.new(DeploymentStrategy::BreakDown)
deploy.run 'group_name'
