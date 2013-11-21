class Kmeans
  attr_accessor :map, :points, :assignments, :centers

  def calculate_new_centers(k)
    dimension = centers.first.size
    self.centers.map do |center|
      cluster = assignments[center]
      mean = []
      sum = Array.new(dimension,0)
      cluster.each do |point|
        dimension.times do |d| #d stands for dimension
          sum[d] += point[d]
        end
      end
      dimension.times do |d|
        mean[d] = sum[d]/cluster.count
      end
      mean
    end
  end

  def self.distance(center, point)
    # (center[0] - point[0])**2 + (center[1] - point[1])**2
    sum = 0
    (0..center.count-1).each do |d|
      sum += (center[d] - point[d])**2
    end
    sum
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
    new_assignment = Hash.new {|hash, key| hash[key] = []}
    assignments.values.flatten(1).each do |point|
      new_cluster = centers.min_by do |center|
        distance(center,point)
      end
      new_assignment[new_cluster] << point
    end
    self.assignments = new_assignment
   #old_assignments.sort != assignments.sort #changed?
  end


  def cluster(k,points,max_iters)
    self.assignments = {}
    points.uniq.shuffle.take(k).each do |center|
      self.assignments[center] = []
    end
    points.each do |point|
      self.assignments[assignments.keys.sample] << point
    end
    self.centers = assignments.keys
    iter = 0
    begin 
      self.centers = calculate_new_centers(k)
      reassign_groups(centers)
      iter += 1
    end  while iter <= max_iters
    self.assignments
  end # end of cluster method


end # end of class
