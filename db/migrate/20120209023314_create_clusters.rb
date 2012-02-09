class CreateClusters < ActiveRecord::Migration
  def change
    create_table :clusters do |t|
      t.integer :word_id
      t.string :word_en_name
      t.integer :gitem_id
      t.string :title
      t.string :link
      t.text :description
      t.integer :size
      t.integer :gmax_count

      t.timestamps
    end
  end
end
