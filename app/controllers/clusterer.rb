# rails: given Word, Gitem and Cluster model
# 

require 'similarity'

class Clusterer

  #update gitems and clusters
  def update_feed_with_url(feed_id, feed_url)
    word = Word.find(feed_id)
    clusters = word.clusters
    p "import #{feed_id} from #{feed_url} ......"
    content = open(feed_url).read
    content.force_encoding('utf-8')
    feed = RSS::Parser.parse(content); puts 'feed ' + feed.items.size.to_s
    items = extract_items(feed)
    ignored_count = 0; imported_count = 0;
    items.each do |gitem|
      if !Gitem.where(:link => gitem.link).empty?; ignored_count = ignored_count+1; next; end
      #word_id:integer word_en_name:string raw_title:string raw_link:string raw_description:text pubdate:datetime title:string link:string description:text source:string count:integer cluster_id:integer
      p = Gitem.new(
        :word_id => feed_id,
        :word_en_name => word.en_name,
        :raw_title => gitem.raw_title,
        :raw_description => gitem.raw_description,
        :raw_link => gitem.raw_link,
        :title => gitem.title, 
        :link => gitem.link,
        :description => gitem.description,
        :pubdate => gitem.date,
        :source => gitem.source,
        :count => gitem.count
      )
      p.save
      cluster_item(p, clusters)
      imported_count = imported_count + 1
    end
    p "imported #{imported_count} items; ignored #{ignored_count} items"
  end
  
  def cluster_item(item, clusters)
    threshold = 0.5
    clusters.each { |cluster|
      if Similarity.new(threshold).is_similar(item, cluster)
        cluster.gitems.push(item);
        cluster.size = cluster.gitems.size;
        cluster.gmax_count = item.count if (cluster.gmax_count < item.count) 
        cluster.save
        return; 
      end
    }
    create_cluster_with_item(item, clusters)
  end
  
  def create_cluster_with_item(item, clusters)
    cluster = Cluster.create(
                 :title => item.title,
                 :word_en_name => item.word_en_name, 
                 :description => item.description,
                 :link => item.link,
                 :size => 1,
                 :gmax_count => item.count)
    cluster.gitems.push(item);
    cluster.save
    clusters.push(cluster)
  end

  # cut association between Gitem and Cluster and clear the clustered items
  def clear_cluster_by_name(name)
    Cluster.where(:word_en_name => name).delete_all
    Gitem.where(:word_en_name => name).update_all(:cluster_id => nil)
  end

  # cluster those unclustered items
  def cluster_by_word_en_name(name)
    clusters = Cluster.where(:word_en_name => name).all #modify later, use only recent N clusters
    un_clustered_items = Gitem.where(:word_en_name => name, :cluster_id => nil).all
    un_clustered_items.each { |item| cluster_item(item, clusters) }
  end

end

#c = Clusterer.new(0.5)
#c.clear_cluster('google')
#c.clear_cluster('twitter')
#c.cluster_by_word_en_name('google')
