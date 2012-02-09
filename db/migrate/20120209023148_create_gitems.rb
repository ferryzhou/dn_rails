class CreateGitems < ActiveRecord::Migration
  def change
    create_table :gitems do |t|
      t.integer :word_id
      t.string :word_en_name
      t.string :raw_title
      t.string :raw_link
      t.text :raw_description
      t.datetime :pubdate
      t.string :title
      t.string :link
      t.text :description
      t.string :source
      t.integer :count
      t.integer :cluster_id

      t.timestamps
    end
  end
end
