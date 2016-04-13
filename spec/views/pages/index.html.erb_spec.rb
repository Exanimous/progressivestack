# spec/views/pages/index.html.erb_spec.rb
require 'rails_helper'

describe 'pages/index.html.erb' do
  it 'View: display the home page correctly' do

    render

    expect(rendered).to include('Hello world!')
  end
end