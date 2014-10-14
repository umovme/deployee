
class ScaleLoadBalancer

  def intialize lb
    @delegate = lb
  end

  def healthy_instances
    @delegate.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

end
