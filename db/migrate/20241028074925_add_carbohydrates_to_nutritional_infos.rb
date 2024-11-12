class AddCarbohydratesToNutritionalInfos < ActiveRecord::Migration[7.1]
  def change
    change_table :nutritional_infos do |t|
      t.decimal :carbohydrates, precision: 10, scale: 2
    end
  end
end
