# spec/controllers/pages_controller_spec.rb
require 'rails_helper'

RSpec.describe PagesController do
  describe 'GET #index' do
    it 'Controller: renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
end