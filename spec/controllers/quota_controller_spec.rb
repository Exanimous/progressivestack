# spec/controllers/quota_controller_spec.rb
require 'rails_helper'

RSpec.describe QuotaController, type: :controller do
  describe 'GET #index' do

    context 'signed in as user' do
      login_user

      it 'Controller: populates AccessControl object' do
        quotum = FactoryGirl.create(:quotum, tenant_id: @current_user.tenant_ids.first)
        get :index
        expect(assigns(:access_control)).to be_a(AccessControl)
      end

      it 'Controller: populates array of (controllable) quota' do
        quotum = FactoryGirl.create(:quotum, tenant_id: @current_user.tenant_ids.first)
        get :index
        expect(assigns(:access_control).quota_controllable).to eq([quotum])
      end

      it 'Controller: renders the quota index template' do
        get :index
        expect(response).to render_template('index')
      end
    end

    context 'not signed in' do
      it 'Controller: quota_controllable array is empty' do
        quotum = FactoryGirl.create(:quotum)
        get :index
        expect(assigns(:access_control).quota_controllable).to eq([])
      end

      it 'Controller: quota_viewable array is present' do
        quotum = FactoryGirl.create(:quotum)
        get :index
        expect(assigns(:access_control).quota_view_only).to eq([quotum])
      end
    end
  end

  # show not implemented
  #describe 'GET #show' do
  #  it 'Controller: renders the show view' do
  #    get :show, id: FactoryGirl.create(:quotum)
  #    expect(response).to render_template('show')
  #  end
  #end

  describe 'GET #new' do
    it 'Controller: renders the new view (html)' do
      get :new, params: { slug: FactoryGirl.build(:quotum), format: :html }
      expect(response).to render_template('new')
      expect(response.content_type).to eq(Mime[:html])
    end

    it 'Controller: renders the new view (js)' do
      get :new, xhr: true, params: { slug: FactoryGirl.build(:quotum), format: :js }
      expect(response).to render_template('new')
      expect(response.content_type).to eq(Mime[:js])
    end
  end

  describe 'GET #show' do

    context 'signed in as user' do
      login_user

      it 'Controller: renders the show view (html)' do
        get :show, params: { slug: FactoryGirl.create(:quotum, tenant_id: @current_user.tenant_ids.first), format: :html }
        expect(response).to render_template('show')
        expect(response.content_type).to eq(Mime[:html])
      end

      it 'Controller: renders the show view (js)' do
        get :show, xhr: true, params: { slug: FactoryGirl.create(:quotum, tenant_id: @current_user.tenant_ids.first), format: :js }
        expect(response).to render_template('show')
        expect(response.content_type).to eq(Mime[:js])
      end
    end

    context 'not signed in' do
      it 'Controller: renders the show view (html)' do
        get :show, params: { slug: FactoryGirl.create(:quotum), format: :html }
        expect(response).to render_template('show')
        expect(response.content_type).to eq(Mime[:html])
      end

      it 'Controller: renders the show view (js)' do
        get :show, xhr: true, params: { slug: FactoryGirl.create(:quotum), format: :js }
        expect(response).to render_template('show')
        expect(response.content_type).to eq(Mime[:js])
      end
    end

  end

  describe 'GET #edit' do

    context 'signed in as user' do
      login_user

      it 'Controller: renders the edit view (html)' do
        get :edit, params: { slug: FactoryGirl.create(:quotum, tenant_id: @current_user.tenant_ids.first), format: :html }
        expect(response).to render_template('edit')
        expect(response.content_type).to eq(Mime[:html])
      end

      it 'Controller: renders the edit view (js)' do
        get :edit, xhr: true, params: { slug: FactoryGirl.create(:quotum, tenant_id: @current_user.tenant_ids.first), format: :js }
        expect(response).to render_template('edit')
        expect(response.content_type).to eq(Mime[:js])
      end
    end

    context 'not signed in' do
      it 'Controller: fails to render the edit view (html)' do
        get :edit, params: { slug: FactoryGirl.create(:quotum), format: :html }
        expect(response.status).to eq 404
      end

      it 'Controller: fails to render the edit view (js)' do
        get :edit, xhr: true, params: { slug: FactoryGirl.create(:quotum), format: :js }
        expect(response.status).to eq 404
      end
    end
  end

  # Qoutum Create Action (POST)
  describe "POST #create" do

    context 'signed in as user' do
    login_user

      context "with valid attributes" do
        it 'Controller: successfully creates a new quotum', js: true do
          expect {
            post :create, params: { quotum: FactoryGirl.attributes_for(:quotum), format: :js }
          }.to change(Quotum, :count).by(1)
        end

        it 'Controller: displays flash success', js: true do
          post :create, xhr: true, params: { quotum: FactoryGirl.attributes_for(:quotum) }
          expect(flash[:success]).to be_present
        end
      end

      context "with invalid attributes" do
        it 'Controller: fail to create a new quotum', js: true do
          expect {
            post :create, params: { quotum: FactoryGirl.attributes_for(:invalid_quotum), format: :js }
          }.to_not change(Quotum, :count)
        end

        it 'Controller: displays flash error' do
          post :create, params: { quotum: FactoryGirl.attributes_for(:invalid_quotum), format: :js }
          expect(flash[:error]).to be_present
        end
      end

      context "with invalid recaptcha" do
        before do
          Recaptcha.configuration.skip_verify_env.delete("test")
        end

        after do
          Recaptcha.configuration.skip_verify_env << "test"
        end

        it 'Controller: fail to create a new quotum', js: true do
          expect {
            post :create, params: { quotum: FactoryGirl.attributes_for(:quotum), format: :js }
          }.to_not change(Quotum, :count)
          expect(flash[:error]).to be_present
        end
      end
    end

    context 'not signed in' do
      it 'Controller: creates new quotum and new (guest) user', js: true do
        expect {
          post :create, params: { quotum: FactoryGirl.attributes_for(:quotum), format: :js }
        }.to change { Quotum.count }.by(1).and change{ User.count }.by(1)
      end
    end
  end

  # Qoutum Update Action (PUT)
  describe "PUT #update" do

    context 'signed in as user' do
      login_user

      before :each do
        @quotum = FactoryGirl.create(:quotum, name: "put #update quotum", tenant_id: @current_user.tenant_ids.first)
      end

      context "with valid attributes" do
        it 'Controller: locate requested @quotum', js: true do
          put :update, xhr: true, params: { slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum) }
          expect(assigns(:quotum)).to eq(@quotum)
        end

        it 'update @quotum attributes', js: true do
          new_name = "quotum updated"
          put :update, xhr: true, params: { slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum, name: new_name) }
          @quotum.reload
          expect(@quotum.name).to eq(new_name)
        end

        it 'Controller: displays flash success', js: true do
          put :update, xhr: true, params: { slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum) }
          expect(flash[:success]).to be_present
        end

      end

      context "with invalid attributes" do
        it 'Controller: locate requested @quotum', js: true do
          put :update, xhr: true, params: { slug: @quotum, quotum: FactoryGirl.attributes_for(:invalid_quotum) }
          expect(assigns(:quotum)).to eq(@quotum)
        end

        it 'does not update @quotum attributes', js: true do
          new_name = "quotum updated"
          put :update, xhr: true, params: { slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum, name: nil) }
          @quotum.reload
          expect(@quotum.name).to eq(@quotum.name)
        end

        it 'Controller: displays flash error', js: true do
          put :update, xhr: true, params: { slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum, name: nil) }
          expect(flash[:error]).to be_present
        end
      end
    end

    context 'not signed in' do
      before :each do
        @quotum = FactoryGirl.create(:quotum, name: "put #update quotum")
      end

      it '(quotum is not found) fails to update @quotum attributes', js: true do
        new_name = "quotum updated"
        put :update, xhr: true, params: { slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum, name: new_name) }
        expect(response.status).to eq 404
      end
    end
  end

  # Qoutum destroy Action (DELETE)
  describe 'DELETE #destroy' do

    context 'is signed in as user' do
      login_user

      before :each do
        @quotum = FactoryGirl.create(:quotum, tenant_id: @current_user.tenant_ids.first)
      end

      it 'deletes the quotum', js: true do
        expect {
          delete :destroy, xhr: true, params: { slug: @quotum }
        }.to change(Quotum, :count).by(-1)
      end

      it 'Controller: display notice', js: true do
        delete :destroy, xhr: true, params: { slug: @quotum }
        expect(flash[:notice]).to be_present
      end
    end

    context 'not signed in' do
      before :each do
        @quotum = FactoryGirl.create(:quotum)
      end

      it '(quotum is not found) fails to delete quotum', js: true do
        expect {
          delete :destroy, xhr: true, params: { slug: @quotum }
        }.to_not change(Quotum, :count)
        expect(response.status).to eq 404
      end

    end
  end

end
