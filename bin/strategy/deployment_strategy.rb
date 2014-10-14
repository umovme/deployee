require_relative '../lib/aws_lib'

class DeploymentStrategy

  def wait_until 
    sleep(30)
    begin
      sleep(15)
    end until yield
  end

end
