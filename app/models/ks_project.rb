class KsProject < ActiveRecord::Base
  has_many :ks_project_backers
  has_many :ks_users, :through => :ks_project_backers
  has_many :recommendations

  def still_active?
    begin
    date_array = self.end_date.split
    hour_min_array = date_array[4].split(/:/)
    hour = hour_min_array[0]
    min = hour_min_array[1]
    utc = date_array[5].split(//).insert(3, ":").join
    end_time = Time.new(date_array[3], date_array[2], date_array[1], hour, min, 0)

    end_time > Time.now
    rescue
      puts "error"
    end
  end

  def ending_soon?

  end

end

#Ruby
# 0year, 1month, 2day, 3hour, 4min, 5sec, 6utc_offset
#KS 
# "Sun, 28 Oct 2012 06:59:00 -0000"
#0weekday/junk, 1day, 2month, 3year, 4houretc, 5utc