class Similarity

  def initialize(threshold)
    @threshold = threshold
  end
  
  def distance(item, cluster)
    d1 = string_distance(item.title, cluster.title)
    d2 = string_distance(item.description, cluster.description)
    [d1, d2].min
  end
  
  def is_similar(item, cluster); distance(item, cluster) <= @threshold; end
  
  def charset_from_string(str); str.split(//u).to_set; end

  def set_distance(set1, set2); 1 - Float((set1 & set2).size) / (set1 | set2).size; end

  def string_distance(str1, str2); set_distance(charset_from_string(str1), charset_from_string(str2)); end

end

