# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120209023314) do

  create_table "clusters", :force => true do |t|
    t.integer  "word_id"
    t.string   "word_en_name"
    t.integer  "gitem_id"
    t.string   "title"
    t.string   "link"
    t.text     "description"
    t.integer  "size"
    t.integer  "gmax_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gitems", :force => true do |t|
    t.integer  "word_id"
    t.string   "word_en_name"
    t.string   "raw_title"
    t.string   "raw_link"
    t.text     "raw_description"
    t.datetime "pubdate"
    t.string   "title"
    t.string   "link"
    t.text     "description"
    t.string   "source"
    t.integer  "count"
    t.integer  "cluster_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "words", :force => true do |t|
    t.string   "en_name"
    t.string   "title"
    t.string   "link"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
