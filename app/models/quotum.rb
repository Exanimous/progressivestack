class Quotum < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 4, maximum: 64 }, uniqueness: true
  validates :slug, presence: true, length: { minimum: 4, maximum: 64 }, uniqueness: true unless :name

  before_validation :generate_slug

  def to_param
    slug
  end

  protected

  # only run slug validation if name is present
  def generate_slug
    self.slug ||= name.parameterize if name.present?
  end
end
