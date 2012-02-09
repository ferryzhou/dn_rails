class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :en_name
      t.string :title
      t.string :link
      t.string :category

      t.timestamps
    end
  end
end
