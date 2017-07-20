require 'rails_helper'

RSpec.describe Tenant, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.create(:tenant)).to be_valid
  end
  it "is valid if name is blank" do
    name = '' # blank
    expect(FactoryGirl.build(:tenant, name: name)).to be_valid
  end
  it "is invalid if name is too short" do
    name = '12345'
    expect(FactoryGirl.build(:tenant, name: name)).to_not be_valid
  end
  it "is invalid if name is too long" do
    name = random_string(65) # random 65 characters
    expect(FactoryGirl.build(:tenant, name: name)).to_not be_valid
  end
  it "user_tenant relationship is valid" do
    tenant = FactoryGirl.create(:tenant)
    user_tenant = FactoryGirl.create(:user_tenant)
    tenant.user_tenants << user_tenant
    expect(tenant.user_tenants.where(tenant_id: tenant.id)).to be_present
  end

  def random_string(length)
    (36**(length-1) + rand(36**length - 36**(length-1))).to_s(36)
  end
end
