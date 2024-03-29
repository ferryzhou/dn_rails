class WordsController < ApplicationController
  # GET /words
  # GET /words.json
  def index
    @words = Word.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @words }
    end
  end

  # GET /words/1
  # GET /words/1.json
  def show
    @word = Word.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @word }
    end
  end

  # GET /words/new
  # GET /words/new.json
  def new
    @word = Word.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @word }
    end
  end

  # GET /words/1/edit
  def edit
    @word = Word.find(params[:id])
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(params[:word])

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render json: @word, status: :created, location: @word }
      else
        format.html { render action: "new" }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /words/1
  # PUT /words/1.json
  def update
    @word = Word.find(params[:id])

    respond_to do |format|
      if @word.update_attributes(params[:word])
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word = Word.find(params[:id])
    @word.destroy

    respond_to do |format|
      format.html { redirect_to words_url }
      format.json { head :ok }
    end
  end
  
  #============= Custom functions ==========>
  def update_feed
    @word = Word.find(params[:id])
    Clusterer.new.update_feed_with_url(params[:id], @word.link)
    respond_to do |format|
      format.html { redirect_to words_url }
      format.json { head :ok }
    end
  end
  
  def update_feed_with_url
    Clusterer.new.update_feed_with_url(params[:id], params[:feed_url]);
    respond_to do |format|
      format.html { redirect_to gitems_url }
      format.json { head :ok }
    end
  end

  def update_all_feeds
    words = Word.all
    words.each do | word|
      Clusterer.new.update_feed_with_url(word.id, word.link)
    end
    respond_to do |format|
      format.html { redirect_to words_url }
      format.json { head :ok }
    end
  end

  # clear all contents in gitems and clusters
  def clear_contents
    Gitem.delete_all
    Cluster.delete_all
    respond_to do |format|
      format.html { redirect_to words_url }
      format.json { head :ok }
    end
  end  
end
