class NutritionalInfo < ApplicationRecord
  belongs_to :post

  # Validierungen für Nährwertfelder
  validates :calories, presence: true
  validates :sugar, presence: true
  validates :protein, presence: true
  validates :fat, presence: true
  validates :carbohydrates, presence: true

  def calculate_sugar
    sugar * 0.2
  end
end
