class User < ApplicationRecord
  has_many :posts
  has_many :comments

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  VALID_ROLES = %w[admin lesen author].freeze

  validates :role, inclusion: { in: VALID_ROLES }
  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= 'lesen'
  end
end
