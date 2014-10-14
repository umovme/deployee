
class ScaleInstance
  attr_reader :group

  def initialize instance_id, group
    @delegate = AWS::EC2::Instance.new instance_id;
    @group = group
  end

  def id
    @delegate.id
  end

  def exists?
    @delegate.exists?
  end

  def terminate
    @delegate.terminate
  end

end
