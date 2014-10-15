
module WaitUntil
  
  def wait_until 
    sleep(30)
    begin
      sleep(15)
    end until yield
  end

end
