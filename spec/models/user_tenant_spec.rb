require 'rails_helper'

RSpec.describe UserTenant, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.create(:user_tenant)).to be_valid
  end
  it "tenant relationship is valid" do
    user_tenant = FactoryGirl.create(:user_tenant)
    tenant = FactoryGirl.create(:tenant)
    user_tenant.update_attributes(tenant_id: tenant.id)
    expect(user_tenant.tenant).to be_present
  end
end
