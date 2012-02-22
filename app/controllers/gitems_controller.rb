require 'gnews_items_extractor.rb'

class GitemsController < ApplicationController
  # GET /gitems
  # GET /gitems.json
  def index
    @gitems = Gitem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gitems }
    end
  end

  # GET /gitems/1
  # GET /gitems/1.json
  def show
    @gitem = Gitem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gitem }
    end
  end

  # GET /gitems/new
  # GET /gitems/new.json
  def new
    @gitem = Gitem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gitem }
    end
  end

  # GET /gitems/1/edit
  def edit
    @gitem = Gitem.find(params[:id])
  end

  # POST /gitems
  # POST /gitems.json
  def create
    @gitem = Gitem.new(params[:gitem])

    respond_to do |format|
      if @gitem.save
        format.html { redirect_to @gitem, notice: 'Gitem was successfully created.' }
        format.json { render json: @gitem, status: :created, location: @gitem }
      else
        format.html { render action: "new" }
        format.json { render json: @gitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gitems/1
  # PUT /gitems/1.json
  def update
    @gitem = Gitem.find(params[:id])

    respond_to do |format|
      if @gitem.update_attributes(params[:gitem])
        format.html { redirect_to @gitem, notice: 'Gitem was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @gitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gitems/1
  # DELETE /gitems/1.json
  def destroy
    @gitem = Gitem.find(params[:id])
    @gitem.destroy

    respond_to do |format|
      format.html { redirect_to gitems_url }
      format.json { head :ok }
    end
  end
  
  
  def delete_all
    Gitem.delete_all
    respond_to do |format|
      format.html { redirect_to gitems_url }
      format.json { head :ok }
    end
  end
  
  def update_feed
    update_feed_with_url(params[:feed_id], params[:feed_url]);
    respond_to do |format|
      format.html { redirect_to gitems_url }
      format.json { head :ok }
    end
  end

  def update_feed_with_url(feed_id, feed_url)
    word = Word.find(feed_id)
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
      imported_count = imported_count + 1
    end
    p "imported #{imported_count} items; ignored #{ignored_count} items"
  end

  def update_all_feeds
    words = Word.all
    words.each do | word|
      update_feed_with_url(word.id, word.link)
    end
  end

end
