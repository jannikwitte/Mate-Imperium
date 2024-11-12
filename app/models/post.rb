class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_one :nutritional_info, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :nutritional_info

  # Validierungen
  validates :title, presence: true
  validates :description, presence: true
  validates :basic_knowledge, presence: true
  validates :image, presence: true
  validates :link, presence: true
  validates :best_price, numericality: { allow_nil: true }
  validates :caffeine, numericality: { allow_nil: true }
  validates :rating, numericality: { in: 1..5, allow_nil: true }

  validate :image_format

  attribute :approved, :boolean, default: false

  scope :unapproved, -> { where(approved: false) }

  def calculate_caffeine_rating
    return 1 if caffeine <= 5
    return 2 if caffeine > 6 && caffeine <= 10
    return 3 if caffeine > 11 && caffeine <= 15
    return 4 if caffeine > 16 && caffeine <= 20
    return 5 if caffeine > 30
  end

  private

  def image_format
    if image.attached? && !image.content_type.in?(%('image/png'))
      errors.add(:image, 'muss ein PNG-Bild sein')
    end
  end
end
