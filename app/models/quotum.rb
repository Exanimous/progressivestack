class Quotum < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 4, maximum: 64 }, uniqueness: true
end
