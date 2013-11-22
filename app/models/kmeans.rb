require 'pry'
require 'pry-debugger'
class Kmeans
  attr_accessor :map, :points, :assignments, :centers

  def kmplusplus(k, points_for_sampling)
    points_for_sampling = points_for_sampling.uniq
    centers = []
    centers << points_for_sampling.sample
    points_for_sampling.delete(centers.first)
    (k-1).times do
      max_point = points_for_sampling.max_by do |point|
        sum = 0
        centers.each do |center_2|
          sum += distance(point, center_2)
        end
        sum
      end
      centers << max_point
      points_for_sampling.delete(centers.last)
    end
    centers
  end

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
    seeds = kmplusplus(k,points)
    self.assignments = {}
   #points.uniq.shuffle.take(k).each do |center|
    seeds.each do |seed|
      self.assignments[seed] = []
    end
    points.each do |point|
   #  self.assignments[assignments.keys.sample] << point
      closest_seed = seeds.min_by do |seed|
        distance(seed, point)
      end
      self.assignments[closest_seed] << point
    end
    binding.pry
    self.centers = assignments.keys
    iter = 0
    begin 
      old_centers = self.centers.dup
      self.centers = calculate_new_centers(k)

      self.centers != old_centers ? changed = true : changed = false
      reassign_groups(centers)
      iter += 1
      binding.pry
    end  while iter <= max_iters && changed
    self.assignments
  end # end of cluster method


end # end of class
points = [[4.0,2.0],[4.0,3.0],[4.0,4.0],[1.0,2.0],[1.0,3.0],[1.0,1.0],[3.0,2.0]]
#p Kmeans.new.kmplusplus(3,points)
p Kmeans.new.cluster(5, points, 4)

