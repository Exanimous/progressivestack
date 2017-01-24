# spec/controllers/application_controller_spec.rb
require 'rails_helper'

describe ApplicationController do

  describe "Controller:devise helpers" do
    login_user

    it "should have a current_user" do
      expect(@controller.send(:current_user)).to be_valid
    end

    it "should not have guest" do
      expect(@controller.send(:current_guest)).not_to be_present
    end

    it "user_signed_in? should be true" do
      expect(@controller.send(:user_signed_in?)).to be_present
    end

    it "guest_signed_in? should be false" do
      expect(@controller.send(:guest_signed_in?)).not_to be_present
    end
  end

  describe "Controller:guest_user helpers" do
    include Authentication

    context "standard authentication" do

      it "should create new guest if none found" do
        expect {
          @controller.send(:current_or_guest_user, create = true)
        }.to change { User.count }
      end

      it "should not have a current_user" do
        expect(@controller.send(:current_user)).not_to be_present
      end
    end

    context "login_guest_user test helper" do
      login_guest_user

      it "current_guest/ should be true" do
        expect(@controller.send(:current_guest)).to be_present
      end

      it "guest_signed_in? should be true" do
        expect(@controller.send(:guest_signed_in?)).to be_present
      end
    end

    context "no current user or guest" do

      it "returns nil if no current_user" do
        expect(@controller.send(:current_user)).not_to be_present
      end

      it "user_signed_in? should return false" do
        expect(@controller.send(:user_signed_in?)).to be false
      end

      it "returns new guest if no user and create == true" do
        expect {
          @controller.send(:current_or_guest_user, create = true)
        }.to change { User.count }
      end
    end

    context "compatibility authentication" do
      before do
        @guest_user = login_guest_user_compatibility
      end

      it "should have a guest_user" do
        expect(@controller.send(:current_or_guest_user)).to be_valid
      end

      it "should return guest_user" do
        expect(@controller.send(:current_guest)).to be_valid
      end

      it "user should be guest" do
        expect(@guest_user.is_guest?).to be true
      end

      it "guest_signed_in? should be true" do
        expect(@controller.send(:guest_signed_in?)).to be true
      end

      it "user_signed_in? should be false" do
        expect(@controller.send(:user_signed_in?)).to be false
      end

    end
  end

end