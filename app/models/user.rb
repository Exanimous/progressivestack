class User < ApplicationRecord
  include UserUtilities
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable


  has_many :user_tenants, dependent: :destroy
  has_many :tenants, through: :user_tenants
  has_many :quota, through: :tenants

  after_create :create_tenant

  validates :name, presence: true, length: { minimum: 4, maximum: 64 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, allow_blank: true, length: { maximum: 92 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  scope :guests, -> { where(guest: true) }
  scope :member, -> { where.not(guest: true) }

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
