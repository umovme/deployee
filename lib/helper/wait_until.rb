
module WaitUntil
  
  def wait_until 
    puts "wait_until: start"
    sleep(30)
    puts "wait_until: 30s later"
    begin
      sleep(15)
      puts "wait_until: more 15s"
    end until yield
  end

end
