# given item model and cluster model
# 

require './similarity'

class Clusterer

  def initialize(threshold)
    @sim = Similarity.new(threshold)
  end
  
  def cluster_by_word_en_name(name)
    clusters = Cluster.filter(:word_en_name => name).all #modify later, use only recent N clusters
    un_clustered_items = Gnew.filter(:word_en_name => name, :cluster_id => nil).all
    un_clustered_items.each { |item| cluster_item(item, clusters) }
  end

  def cluster_item(item, clusters)
    clusters.each { |cluster|
      if @sim.is_similar(item, cluster); cluster.add_gnew(item); return; end
    }
    create_cluster_with_item(item, clusters)
  end
  
  def create_cluster_with_item(item, clusters)
    cluster = Cluster.create(:title => item.title, 
	                         :word_en_name => item.word_en_name, :description => item.description)
    cluster.add_gnew(item)
    clusters.push(cluster)
  end

  def clear_cluster(name)
    Cluster.filter(:word_en_name => name).delete
    Gnew.filter(:word_en_name => name).update(:cluster_id => nil)
  end
end

c = Clusterer.new(0.5)
#c.clear_cluster('google')
#c.clear_cluster('twitter')
c.cluster_by_word_en_name('google')
