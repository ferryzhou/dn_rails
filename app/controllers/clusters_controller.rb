require 'similarity.rb'


class ClustersController < ApplicationController
  # GET /clusters
  # GET /clusters.json
  def index
    @clusters = Cluster.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clusters }
    end
  end

  # GET /clusters/1
  # GET /clusters/1.json
  def show
    @cluster = Cluster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cluster }
    end
  end

  # GET /clusters/new
  # GET /clusters/new.json
  def new
    @cluster = Cluster.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cluster }
    end
  end

  # GET /clusters/1/edit
  def edit
    @cluster = Cluster.find(params[:id])
  end

  # POST /clusters
  # POST /clusters.json
  def create
    @cluster = Cluster.new(params[:cluster])

    respond_to do |format|
      if @cluster.save
        format.html { redirect_to @cluster, notice: 'Cluster was successfully created.' }
        format.json { render json: @cluster, status: :created, location: @cluster }
      else
        format.html { render action: "new" }
        format.json { render json: @cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clusters/1
  # PUT /clusters/1.json
  def update
    @cluster = Cluster.find(params[:id])

    respond_to do |format|
      if @cluster.update_attributes(params[:cluster])
        format.html { redirect_to @cluster, notice: 'Cluster was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clusters/1
  # DELETE /clusters/1.json
  def destroy
    @cluster = Cluster.find(params[:id])
    @cluster.destroy

    respond_to do |format|
      format.html { redirect_to clusters_url }
      format.json { head :ok }
    end
  end

  #============== background processing begin ============>
  
  def cluster_feed
    cluster_by_word_en_name(params[:feed_name])
    respond_to do |format|
      format.html { redirect_to clusters_url }
      format.json { head :ok }
    end
  end
  
  def clear_feed
    clear_cluster_by_name(params[:feed_name])
    respond_to do |format|
      format.html { redirect_to clusters_url }
      format.json { head :ok }
    end
  end
  
  def cluster_by_word_en_name(name)
    clusters = Cluster.where(:word_en_name => name).all #modify later, use only recent N clusters
    un_clustered_items = Gitem.where(:word_en_name => name, :cluster_id => nil).all
    un_clustered_items.each { |item| cluster_item(item, clusters) }
  end

  def cluster_item(item, clusters)
    threshold = 0.5
    clusters.each { |cluster|
      if Similarity.new(threshold).is_similar(item, cluster)
        #cluster.add_gitem(item); 
        item.cluster_id = cluster.id
        item.save
        return; 
      end
    }
    create_cluster_with_item(item, clusters)
  end
  
  def create_cluster_with_item(item, clusters)
    cluster = Cluster.create(:title => item.title,
            :word_en_name => item.word_en_name, :description => item.description)
    #cluster.add_gitem(item)
    item.cluster_id = cluster.id
    item.save
    clusters.push(cluster)
  end

  def clear_cluster_by_name(name)
    Cluster.where(:word_en_name => name).delete_all
    Gitem.where(:word_en_name => name).update_all(:cluster_id => nil)
  end

  #============== background processing end ============>
  
end
