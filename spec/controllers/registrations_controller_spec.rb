# spec/controllers/registrations_controller_spec.rb
require 'rails_helper'

describe Users::RegistrationsController do

  describe 'GET #new' do
    it 'Controller: renders the new view (html)' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new, params: { format: :html }
      expect(response).to render_template('new')
    end
  end

  # must be signed in to edit
  describe 'GET #edit' do
    it 'Controller: edit attempt when not signed in - redirect to sign_in' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :edit, params: { id: FactoryGirl.create(:user), format: :html }
      expect(response).to redirect_to new_user_session_path
    end
  end

  # User Create Action (POST)
  describe "POST #create" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    # Background dependency:
    # Action: attempt new registration with valid attributes
    # Expected Behaviour : current user should be present
    context "with valid attributes" do

      before do
        @user = FactoryGirl.attributes_for(:user)
      end

      subject(:register) { post :create, params: { user: @user, format: :html } }

      it 'Controller: successfully creates a new user' do
        expect {
          register
        }.to change(User, :count).by(1)
      end

      it 'Controller: attributes are saved' do
        register
        expect(@controller.send(:current_user)).to have_attributes name: @user[:name], email: @user[:email]
      end

      it 'Controller: displays flash success' do
        register
        expect(flash[:notice]).to be_present
      end

      it 'Controller: redirect to root' do
        register
        expect(response).to redirect_to root_path
      end

      it 'Controller: should be signed in' do
        register
        expect(@controller.send(:current_user)).to be_valid
      end
    end

    # Background dependency:
    # Action: attempt new registration with invalid attributes
    # Expected Behaviour : current user should be nil
    context "with invalid attributes" do

      before do
        @invalid_user = FactoryGirl.attributes_for(:invalid_user)
      end

      subject(:register) { post :create, params: { user: @invalid_user, format: :html } }

      it 'Controller: fail to create a new user' do
        expect {
          register
        }.to_not change(User, :count)
      end

      it 'Controller: invalid password confirmation' do
        expect {
          post :create, params: { user: FactoryGirl.attributes_for(:user, password_confirmation: ''), format: :html }
        }.to_not change(User, :count)
      end

      it 'Controller: return status 200 OK' do
        register
        expect(response.status).to eq(200)
      end
    end

    # Background dependency:
    # Action: attempt new registration with duplicate attributes
    # Expected Behaviour : current user should be nil
    context "with duplicate attributes" do
      before do
        FactoryGirl.create(:user)
        @user = FactoryGirl.attributes_for(:user)
      end

      subject(:register_duplicate) { post :create, params: { user: @user, format: :html } }

      it 'Controller: fail to create a new user' do
        expect {
          register_duplicate
        }.to_not change(User, :count)
      end

      it 'Controller: return status 200 OK' do
        register_duplicate
        expect(response.status).to eq(200)
      end
    end

    context "with invalid recaptcha" do
      before do
        @user = FactoryGirl.attributes_for(:user)
        Recaptcha.configuration.skip_verify_env.delete("test")
      end

      after do
        Recaptcha.configuration.skip_verify_env << "test"
      end

      subject(:register) { post :create, params: { user: @user, format: :html } }

      it 'Controller: fail to create a new quotum', js: true do
        expect {
          register
        }.to_not change(User, :count)
        expect(flash[:error]).to be_present
      end
    end

    # Background dependency: guest signed in
    # Action: attempt new registration with valid attributes
    # Expected Behaviour : current user should be present, guest should be nil
    context "already signed in as a guest" do
      login_guest_user

      subject(:register) { post :create, params: { user: FactoryGirl.attributes_for(:user), format: :html } }

      it 'Controller: before action guest should be signed in' do
        expect(@controller.send(:guest_signed_in?)).to be true
      end

      it 'Controller: creates new user model' do
        expect {
          register
        }.to change(User.member, :count).by(1)
      end

      it 'Controller: current user should be present' do
        register
        expect(@controller.send(:current_user)).to be_present
      end

      it 'Controller: successfully registers - guest should be nil' do
        register
        expect(@controller.send(:guest_signed_in?)).to be false
      end

      it 'Controller: successfully registers - display flash notice' do
        register
        expect(flash[:notice]).to be_present
      end

      it 'Controller: successfully creates a new user and delete guest' do
        register
        expect(User.guests).not_to be_present
      end
    end

    # Background dependency: guest signed in
    # Action: attempt new registration with valid attributes
    # Expected Behaviour : current user should be present, guest should be nil
    context "already signed in" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      subject(:register) { post :create, params: { user: FactoryGirl.attributes_for(:user_two), format: :html } }

      it 'Controller: fail to create new user' do
        expect {
          register
        }.to_not change(User, :count)
      end

      it 'Controller: current user should be present' do
        register
        expect(@controller.send(:current_user)).to be_present
      end

      it 'Controller: register fails -- current_user should have original attributes' do
        register
        expect(@controller.send(:current_user)).to have_attributes name: @user.name, email: @user.email, id: @user.id
      end
    end
  end

  # User Update Action (POST)
  describe "POST #update" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.build(:user, name: "put #update user", email: "put_temp@email.com")
    end

    # Background dependency: user signed in
    # Action: attempt registration update with valid attributes
    # Expected Behaviour : current user should be present
    context "with valid attributes" do
      login_user

      before do
        @user = FactoryGirl.attributes_for(:user, current_password: 'hunter2')
      end

      subject(:update_registration) { put :update, params: { user: @user, format: :html } }

      it 'Controller: before action user should be signed in' do
        expect(@controller.send(:current_user)).to be_present
      end

      it 'Controller: locate requested @user' do
        update_registration
        expect(assigns(:user)).to eq(@controller.send(:current_user))
      end

      it 'Controller: should be signed in' do
        update_registration
        expect(@controller.send(:current_user)).to be_valid
      end

      it 'Controller: update @user email' do
        new_email = FactoryGirl.attributes_for(:user)[:email]
        put :update, params: { user: FactoryGirl.attributes_for(:user, current_password: 'hunter2', email: new_email) }
        expect(@controller.send(:current_user).email).to eq(new_email)
      end

      it 'Controller: redirect to root' do
        update_registration
        expect(response).to redirect_to root_path
      end
    end

    # Background dependency: user signed in
    # Action: attempt registration update with invalid attributes
    # Expected Behaviour : current user should be present, but unchanged
    context "with invalid attributes" do
      login_user

      before do
        @invalid_email = "email updated"
      end

      it 'before action user should be signed in' do
        expect(@controller.send(:current_user)).to be_present
      end

      it 'locate requested @user' do
        put :update, params: { user: FactoryGirl.attributes_for(:invalid_user) }
        expect(assigns(:user)).to eq(@controller.send(:current_user))
      end

      it 'does not update @user email' do
        put :update, params: { user: FactoryGirl.attributes_for(:user, current_password: 'hunter2', email: @invalid_email) }
        expect(@controller.send(:current_user).email).not_to eq(@invalid_email)
      end

      it 'does not update if password invalid' do
        put :update, params: { user: FactoryGirl.attributes_for(:user, current_password: '', email: @user.email) }
        expect(@controller.send(:current_user).email).not_to eq(@user.email)
      end

      it 'return status 200 OK' do
        put :update, params: { user: FactoryGirl.attributes_for(:invalid_user) }
        expect(response.status).to eq(200)
      end
    end

    # Background dependency: guest user signed in
    # Action: attempt registration update with valid attributes
    # Expected Behaviour : action should fail
    context "as guest user" do
      login_guest_user

      before do
        @guest_user = FactoryGirl.attributes_for(:guest)
      end

      subject(:update_registration) { put :update, params: { user: @guest_user, format: :html } }

      it 'before action user should be signed in' do
        expect(@controller.send(:current_guest)).to be_present
      end

      it 'locate requested @user' do
        update_registration
        expect(assigns(:guest)).not_to eq(@controller.send(:current_guest))
      end

      it 'does not update @user name' do
        updated_name = 'custom-guest-name'
        put :update, params: { user: FactoryGirl.attributes_for(:guest, name: updated_name) }
        expect(@controller.send(:current_guest).name).not_to eq(updated_name)
      end

      it 'return status 403 Forbidden' do
        update_registration
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE #destroy' do

    # Background dependency: user signed in
    # Action: attempt registration destroy
    # Expected Behaviour : current user should be nil
    context "while signed in as user" do
      login_user

      subject(:delete_registration) { delete :destroy, params: { user: @current_user } }

      it 'before action user should be signed in' do
        expect(@controller.send(:current_user)).to be_present
      end

      it 'deletes the user' do
        expect {
          delete_registration
        }.to change(User, :count).by(-1)
      end

      it 'display notice', js: true do
        delete_registration
        expect(flash[:notice]).to be_present
      end

      it 'should be signed out' do
        delete_registration
        expect(@controller.send(:current_user)).not_to be_present
      end

      it 'should redirect to root' do
        delete_registration
        expect(response).to redirect_to root_path
      end
    end

    # Background dependency:
    # Action: attempt registration destroy
    # Expected Behaviour : action should fail
    context "while signed in as guest" do
      login_guest_user

      subject(:delete_registration) { delete :destroy, params: { user: @current_guest } }

      it 'before action guest should be signed in' do
        expect(@controller.send(:current_guest)).to be_present
      end

      it 'return status 403 Forbidden' do
        delete_registration
        expect(response.status).to eq(403)
      end

      it 'does not delete the user' do
        expect {
          delete_registration
        }.to change(User, :count).by(0)
      end

      it 'should be signed in' do
        delete_registration
        expect(@controller.send(:current_guest)).to be_present
      end
    end
  end
end