class User < ApplicationRecord
  include UserUtilities
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  after_create :create_tenant
  before_destroy :delete_quota

  has_many :user_tenants, dependent: :destroy
  has_many :tenants, through: :user_tenants, dependent: :destroy
  has_many :quota, through: :tenants # destroy case handled in callbacks


  validates :name, presence: true, length: { minimum: 4, maximum: 64 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, allow_blank: true, length: { maximum: 92 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  scope :guests, -> { where(guest: true) }
  scope :member, -> { where.not(guest: true) }

  # ** Start of Callbacks

  # dependent: :destroy will fail with 'HasManyThroughNestedAssociationsAreReadonly' error
  # explicitly clean up associated objects instead
  def delete_quota
    Quotum.where(id: quotum_ids).delete_all
  end

  # ** End of Callbacks

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def is_guest?
    self.guest
  end

  def create_tenant
    tenant = Tenant.new(name: self.name)
    self.user_tenants << UserTenant.new(tenant: tenant, permission_level: 3)
  end
end
