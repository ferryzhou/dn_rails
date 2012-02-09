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
end
