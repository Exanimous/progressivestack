require 'rails_helper'

RSpec.describe User, type: :model do

  it "is valid with valid attributes" do
    expect(FactoryGirl.build(:user)).to be_valid
  end
  it "is invalid with invalid attributes" do
    expect(FactoryGirl.build(:invalid_user)).to_not be_valid
  end
  it "is invalid without a name" do
    expect(FactoryGirl.build(:user, name: nil)).to_not be_valid
  end
  it "is invalid if name is not unique" do
    name = 'Testing 12345'
    FactoryGirl.create(:user, name: name)
    expect(FactoryGirl.build(:user, name: name)).to_not be_valid
  end
  it "is invalid if name is too short" do
    name = random_string(3) # random 3 characters
    expect(FactoryGirl.build(:user, name: name)).to_not be_valid
  end
  it "is invalid if name is too long" do
    name = random_string(129) # random 129 characters
    expect(FactoryGirl.build(:user, name: name)).to_not be_valid
  end

  it "is invalid if email is too long" do
    email = "#{random_string(64)}@#{random_string(64)}.com"
    expect(FactoryGirl.build(:user, email: email)).to_not be_valid
  end

  it "is invalid if email format is invalid" do
    email = "test12345"
    expect(FactoryGirl.build(:user, email: email)).to_not be_valid
  end

  it "is invalid if email is not unique" do
    user = FactoryGirl.create(:user)
    expect(FactoryGirl.build(:user, name: user.email)).to_not be_valid
  end

  def random_string(length)
    (36**(length-1) + rand(36**length - 36**(length-1))).to_s(36)
  end
end
