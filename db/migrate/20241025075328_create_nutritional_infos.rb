class CreateNutritionalInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :nutritional_infos do |t|
      t.decimal :calories
      t.decimal :sugar
      t.decimal :protein
      t.decimal :fat
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
