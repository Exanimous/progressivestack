class Tenant < ApplicationRecord
  has_many :user_tenants
  has_many :users, through: :user
  has_many :quota

  validates :name, allow_blank: true, length: { minimum: 6, maximum: 64 }
end
