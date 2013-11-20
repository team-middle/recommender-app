class Kmeans
  attr_accessor :map, :points, :assignments, :centers

  def calculate_new_centers(k)
    self.centers.map do |group|
      group_arr = assignments.select do |assignment|
        assignment[1] == group
      end
      sum = []
      mean = []
      (0..group.count-1).each do |d|  
        sum[d] = 0
      end
      group_arr.each do |point|
        (0..group.count-1).each do |d|
          sum[d] += point[0][d]
        end
      end
      if group_arr.count != 0
        (0..group.count-1).each do |d|
          mean[d] = sum[d]/group_arr.count
        end
      end
      mean
    end
  end

  def distance(center, point)
    # (center[0] - point[0])**2 + (center[1] - point[1])**2
    sum = 0
    (0..center.count-1).each do |d|
      sum += (center[d] - point[d])**2
    end
    sum
  end

  def reassign_groups(centers)
    assignments.each do |assignment|
      point = assignment[0]
      new_group = centers.min_by do |center|
        distance(center,point)
      end
      assignment[1] = new_group
    end
   #old_assignments.sort != assignments.sort #changed?
  end


  def cluster(k,points,max_iters)
    self.assignments = []

    #self.centers = [[1,1,1],[4,4,4],[0,3,2],[4,0,0]]
    self.centers = points.shuffle.take(k)
    points.each do |point|
      self.assignments << [point, centers[rand(0..centers.count-1)]]
    end
  
    iter = 0
    begin 
      self.centers = calculate_new_centers(k)
      reassign_groups(centers)
      iter += 1
    end  while iter <= max_iters

    clean_hash = Hash[*assignments.flatten(1)]
    inverse = Hash.new() { |hash, key| hash[key] = []; }
    clean_hash.each_pair() { |key, value| inverse[value].push(key); }
    inverse
  end # end of cluster method

  # def centers_to_database
  #   self.centers.each_with_index do |center, i|
  #     Center.add_center(center[i])
  # end


end # end of class
