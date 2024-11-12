class AddCaffeineRatingToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :caffeine_rating, :integer
  end
end
