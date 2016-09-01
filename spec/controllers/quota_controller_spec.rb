# spec/controllers/quota_controller_spec.rb
require 'rails_helper'

RSpec.describe QuotaController, type: :controller do
  describe 'GET #index' do
    it 'Controller: populates array of quota' do
      quotum = FactoryGirl.create(:quotum)
      get :index
      expect(assigns(:quota)).to eq([quotum])
    end

    it 'Controller: renders the quota index template' do
      get :index
      expect(response).to render_template('index')
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
      get :new, format: 'html', slug: FactoryGirl.build(:quotum)
      expect(response).to render_template('new')
      expect(response.content_type).to eq(Mime::HTML)
    end

    it 'Controller: renders the new view (js)' do
      xhr :get, :new, format: 'js', slug: FactoryGirl.build(:quotum)
      expect(response).to render_template('new')
      expect(response.content_type).to eq(Mime::JS)
    end
  end

  describe 'GET #edit' do
    it 'Controller: renders the edit view (html)' do
      get :edit, format: 'html', slug: FactoryGirl.create(:quotum)
      expect(response).to render_template('edit')
      expect(response.content_type).to eq(Mime::HTML)
    end

    it 'Controller: renders the edit view (js)' do
      xhr :get, :edit, format: 'js', slug: FactoryGirl.create(:quotum)
      expect(response).to render_template('edit')
      expect(response.content_type).to eq(Mime::JS)
    end
  end

  # Qoutum Create Action (POST)
  describe "POST #create" do
    context "with valid attributes" do
      it 'Controller: successfully creates a new quotum', js: true do
        expect {
          post :create, format: 'js', quotum: FactoryGirl.attributes_for(:quotum)
        }.to change(Quotum, :count).by(1)
      end

      it 'Controller: displays flash success', js: true do
        xhr :post, :create, quotum: FactoryGirl.attributes_for(:quotum)
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid attributes" do
      it 'Controller: fail to create a new quotum', js: true do
        expect {
          post :create, format: 'js', quotum: FactoryGirl.attributes_for(:invalid_quotum)
        }.to_not change(Quotum, :count)
      end

      it 'Controller: displays flash error' do
        post :create, format: 'js', quotum: FactoryGirl.attributes_for(:invalid_quotum)
        expect(flash[:error]).to be_present
      end
    end
  end

  # Qoutum Update Action (PUT)
  describe "PUT #update" do
    before :each do
      @quotum = FactoryGirl.create(:quotum, name: "PUT #update quotum")
    end

    context "with valid attributes" do
      it 'Controller: locate requested @quotum', js: true do
        xhr :put, :update, slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum)
        expect(assigns(:quotum)).to eq(@quotum)
      end

      it 'update @quotum attributes', js: true do
        new_name = "Quotum updated"
        xhr :put, :update, slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum, name: new_name)
        @quotum.reload
        expect(@quotum.name).to eq(new_name)
      end

      it 'Controller: displays flash success', js: true do
        xhr :put, :update, slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum)
        expect(flash[:success]).to be_present
      end

    end

    context "with invalid attributes" do
      it 'Controller: locate requested @quotum', js: true do
        xhr :put, :update, slug: @quotum, quotum: FactoryGirl.attributes_for(:invalid_quotum)
        expect(assigns(:quotum)).to eq(@quotum)
      end

      it 'does not update @quotum attributes', js: true do
        new_name = "Quotum updated"
        xhr :put, :update, slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum, name: nil)
        @quotum.reload
        expect(@quotum.name).to eq(@quotum.name)
      end

      it 'Controller: displays flash error', js: true do
        xhr :put, :update, slug: @quotum, quotum: FactoryGirl.attributes_for(:quotum, name: nil)
        expect(flash[:error]).to be_present
      end
    end
  end

  # Qoutum destroy Action (DELETE)
  describe 'DELETE #destroy' do
    before :each do
      @quotum = FactoryGirl.create(:quotum)
    end

    it 'deletes the quotum', js: true do
      expect {
        xhr :delete, :destroy, slug: @quotum
      }.to change(Quotum, :count).by(-1)
    end

    it 'Controller: display notice', js: true do
      xhr :delete, :destroy, slug: @quotum
      expect(flash[:notice]).to be_present
    end
  end

end
