# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'

describe Users::SessionsController do

  describe 'GET #new' do
    it 'Controller: renders the new view (html)' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new, params: { format: :html }
      expect(response).to render_template('new')
    end
  end

  # Session Create Action (POST)
  describe "POST #create" do
    include Authentication
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      @user_two = FactoryGirl.create(:user_two)
    end

    # Background dependency:
    # Action: attempt new session with valid attributes
    # Expected Behaviour : current user should be present
    context "with valid attributes" do
      before do
        post :create, params: { user:  { name: @user.name, password: @user.password },
                                                  format: :html }
      end

      it 'Controller: successfully signs in' do
        expect(@controller.send(:current_user)).to be_valid
      end

      it 'Controller: displays flash notice' do
        expect(flash[:notice]).to be_present
      end

      it 'Controller: current_user id should be user id' do
        expect(@controller.send(:current_user)).to have_attributes id: @user.id
      end

      it 'Controller: redirect to root' do
        expect(response).to redirect_to root_path
      end
    end

    # Background dependency:
    # Action: attempt new session with invalid password
    # Expected Behaviour : current user should be nil
    context "with invalid password" do
      before do
        post :create, params: { user:  { name: @user.name, password: 'xxxxxxxx' },
                                                  format: :html }
      end

      it 'Controller: sign in fails' do
        expect(@controller.send(:current_user)).not_to be_present
      end

      it 'Controller: displays flash error' do
        expect(flash[:alert]).to be_present
      end

      it 'Controller: redirect to form view' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    # Background dependency:
    # Action: attempt new session with invalid (nil) user
    # Expected Behaviour : current user should be nil
    context "with invalid user" do
      before do
        post :create, params: { user:  { name: 'unknown user', password: 'xxxxxxxx' },
                                                  format: :html }
      end

      it 'Controller: sign in fails' do
        expect(@controller.send(:current_user)).not_to be_present
      end

      it 'Controller: displays flash error' do
        expect(flash[:alert]).to be_present
      end

      it 'Controller: redirect to form view' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    # Background dependency: user signed in
    # Action: attempt new unique session with valid attributes
    # Expected Behaviour : current user should be present and maintain original attributes, new session should be nil
    context "already signed in as different user" do
      before do
        sign_in @user
      end

      subject(:create_session) { post :create, params: { user:  { name: @user_two.name, password: @user_two.password }, format: :html } }

      it 'Controller: before action should be signed in' do
        expect(@controller.send(:current_user)).to be_present
      end

      it 'Controller: sign in fails -- current_user should have original attributes' do
        create_session
        expect(@controller.send(:current_user)).to have_attributes name: @user.name, email: @user.email, id: @user.id
      end

      it 'Controller: sign in fails with flash error' do
        create_session
        expect(flash[:alert]).to be_present
      end

      it 'Controller: redirect to root' do
        create_session
        expect(response).to redirect_to root_path
      end
    end

    # Background dependency:
    # Action: attempt new guest session
    # Expected Behaviour : current guest should be nil
    # Notes: ** guest users must never be allowed to sign in due to absence of authentication **
    context "sign in as guest user" do
      before do
        @current_guest = FactoryGirl.create(:guest_skip_validate)
      end

      subject(:create_guest_session) { post :create, params: { user:  { name: @current_guest.name, password: @current_guest.password }, format: :html } }

      it 'Controller: fails to sign in' do
        create_guest_session
        expect(@controller.send(:guest_signed_in?)).not_to be true
      end

      it 'Controller: sign in fails with flash error' do
        create_guest_session
        expect(flash[:notice]).to be_present
      end

      it 'Controller: redirect to root' do
        create_guest_session
        expect(response).to redirect_to root_path
      end
    end

    # Background dependency: guest user signed in
    # Action: attempt new session with valid attributes
    # Expected Behaviour : current user should be present and signed in, guest user should be nil and destroyed
    context "with valid attributes : already a guest" do
      login_guest_user

      subject(:create_session) { post :create, params: { user:  { name: @user.name, password: @user.password }, format: :html } }

      it 'Controller: before action guest should be signed in' do
        expect(@controller.send(:guest_signed_in?)).to be true
      end

      it 'Controller: successfully signs in - display flash notice' do
        create_session
        expect(flash[:notice]).to be_present
      end

      it 'Controller: successfully signs in - guest should be nil' do
        create_session
        expect(@controller.send(:current_guest)).to be nil
      end

      it 'Controller: successfully signs in - current user should be present' do
        create_session
        expect(@controller.send(:current_user)).to be_present
      end

      it 'Controller: successfully signs in - user should have correct attributes' do
        create_session
        expect(@controller.send(:current_user)).to have_attributes name: @user.name, email: @user.email
      end

      # new user is created, old guest is destroyed
      it 'Controller: successfully signs in - guest user model should be destroyed' do
        create_session
        expect(User.guests).not_to be_present
      end

      it 'Controller: redirect to root' do
        create_session
        expect(response).to redirect_to root_path
      end
    end


    # Background dependency: guest user signed in
    # Action: attempt new session with invalid attributes
    # Expected Behaviour : guest user should be present and signed in, current user should be nil
    context "with invalid attributes : already a guest" do
      login_guest_user

      subject(:create_invalid_session) { post :create, params: { user:  { name: 'unknown user', password: 'xxxxxxxx' }, format: :html } }

      it 'Controller: before action guest should be signed in' do
        expect(@controller.send(:guest_signed_in?)).to be true
      end

      it 'Controller: fails to sign in - display flash alert' do
        create_invalid_session
        expect(flash[:alert]).to be_present
      end

      it 'Controller: fails to sign in - original guest should be present' do
        create_invalid_session
        expect(@controller.send(:guest_signed_in?)).to be true
      end

      it 'Controller: fails to sign in - current_user should be nil' do
        create_invalid_session
        expect(@controller.send(:current_user)).not_to be_present
      end

      it 'Controller: fails to sign in - guest user model should be present' do
        create_invalid_session
        expect(User.guests).to be_present
      end

      it 'Controller: redirect to root' do
        create_invalid_session
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # Session Destroy Action (DELETE)
  describe "DELETE #destroy" do
    include Authentication
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      @user_two = FactoryGirl.create(:user_two)
    end

    # Background dependency: current user signed in
    # Action: destroy session
    # Expected Behaviour : current user should be nil
    context "sign out as user" do
      before do
        sign_in @user
      end

      subject(:destroy_session) { delete :destroy, params: { id: @user.id, format: :html } }

      it 'Controller: before action user should be signed in' do
        expect(@controller.send(:current_user)).to be_present
      end

      it 'Controller: sign out - current user should be nil' do
        destroy_session
        expect(@controller.send(:current_user)).not_to be_present
      end

      it 'Controller: sign out - display flash notice' do
        destroy_session
        expect(flash[:notice]).to be_present
      end

      it 'Controller: current_user session id should nil' do
        destroy_session
        expect(session[:current_user_id]).to be_nil
      end

      it 'Controller: redirect to root' do
        destroy_session
        expect(response).to redirect_to root_path
      end
    end

    # Background dependency: guest user signed in
    # Action: destroy session
    # Expected Behaviour : guest user should be nil and model deleted
    context "sign out as guest user" do
      login_guest_user

      subject(:destroy_session) { delete :destroy, params: { format: :html } }

      it 'Controller: before action guest should be signed in' do
        expect(@controller.send(:current_guest)).to be_present
      end

      it 'Controller: sign out - guest should be nil' do
        pending("needs fixed")
        raise "test skipped"
        destroy_session
      end

      it 'Controller: sign out - display flash notice' do
        destroy_session
        expect(flash[:notice]).to be_present
      end

      it 'Controller: redirect to root' do
        destroy_session
        expect(response).to redirect_to root_path
      end

      it 'Controller: guest model should be deleted' do
        pending("needs fixed")
        raise "test skipped"
        destroy_session
        expect(User.guests.count).to eq(0)
      end
    end

    # Background dependency:
    # Action: destroy session
    # Expected Behaviour : should fail
    context "sign out without being signed in" do

      subject(:destroy_session) { delete :destroy, params: { format: :html } }

      it 'Controller: before action guest should not be signed in' do
        expect(@controller.send(:current_guest)).not_to be_present
      end

      it 'Controller: sign out - display flash notice' do
        destroy_session
        expect(flash[:notice]).to be_present
      end

      it 'Controller: redirect to root' do
        destroy_session
        expect(response).to redirect_to root_path
      end
    end
  end
end