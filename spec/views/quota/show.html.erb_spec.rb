# spec/views/quota/show.html.erb_spec.rb
require 'rails_helper'

describe 'quota/show' do
  before :each do
    @access_control = AccessControl.new(nil)
    @quotum = FactoryGirl.create(:quotum, name: "rspec show quotum")
  end


  it 'View: display quota show html page correctly' do

    render
    expect(rendered).to render_template(partial: "_show")
    expect(rendered).to include('this is a placeholder...')
  end

  it 'View: display quota show js page correctly', js: true do

    render
    expect(rendered).to render_template(partial: "_show")
    expect(rendered).to include('this is a placeholder...')
  end
end



