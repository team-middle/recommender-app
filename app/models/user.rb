class User < ActiveRecord::Base

    def user_data_as_coordinate
    array = (1..13).collect do |i|
      self.send("c#{i}")
    end
  end

  
end
