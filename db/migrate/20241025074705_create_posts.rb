class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.integer :rating
      t.string :image_url
      t.text :nutritional_values

      t.timestamps
    end
  end
end
