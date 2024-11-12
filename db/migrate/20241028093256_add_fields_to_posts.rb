class AddFieldsToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :link, :string
    add_column :posts, :best_price, :decimal
    add_column :posts, :caffeine, :integer
    add_column :posts, :company_description, :text
  end
end
