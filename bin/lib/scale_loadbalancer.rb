
class ScaleLoadBalancer

  def initialize lb_name
    @delegate = lb_name
  end

  def healthy_instances
    @delegate.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

end
