require 'rails_helper'

RSpec.describe Quotum, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:quotum)).to be_valid
  end
  it "is invalid without a name" do
    expect(FactoryGirl.build(:quotum, name: nil)).to_not be_valid
  end
  it "is invalid if name is not unique" do
    name = 'Testing 12345'
    FactoryGirl.create(:quotum, name: name)
    expect(FactoryGirl.build(:quotum, name: name)).to_not be_valid
  end
  it "is invalid if name is too short" do
    name = random_string(3) # random 3 characters
    expect(FactoryGirl.build(:quotum, name: name)).to_not be_valid
  end
  it "is invalid if name is too long" do
    name = random_string(129) # random 129 characters
    expect(FactoryGirl.build(:quotum, name: name)).to_not be_valid
  end

  def random_string(length)
    (36**(length-1) + rand(36**length - 36**(length-1))).to_s(36)
  end

end
