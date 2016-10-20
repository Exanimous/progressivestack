class Quotum < ActiveRecord::Base
  include Rakismet::Model
  rakismet_attrs content: :name

  validates :name, presence: true, length: { minimum: 4, maximum: 64 }, uniqueness: true
  validates_length_of :slug, maximum: 64
  validate :slug_uniqueness

  before_validation :downcase_fields
  before_validation :generate_slug
  after_save :check_for_spam

  # only display quota that are approved
  scope :visible, -> { where(approved: true) }

  def to_param
    slug
  end

  # prevent situations where name is valid but slug is not (due to parameterize removing characters)
  def slug_uniqueness
    if name? and slug? and Quotum.where(slug: slug).where.not(id: id).exists?
      errors.add(:name, "is unavailable")
    end
  end

  protected

  def downcase_fields
    self.name.downcase! if name.present?
  end

  # only run slug validation if name is present
  def generate_slug
    self.slug ||= name.parameterize if name.present?
  end

  # check quotom :name for spam by calling Askimet API
  def check_for_spam
    if self.spam?
      self.update_column(:approved, false)
    elsif !approved
      self.update_column(:approved, true)
    end
  end
end
