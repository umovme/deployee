require 'aws-sdk'

class ScaleLoadBalancer

  def initialize lb_name
    @delegate = AWS::ELB::LoadBalancer.new lb_name
  end

  def healthy_instances
    @delegate.instances.health.count do |health|
      health[:state] == 'InService'
    end
  end

end
