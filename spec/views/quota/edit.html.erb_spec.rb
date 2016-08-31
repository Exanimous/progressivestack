# spec/views/quota/edit.html.erb_spec.rb
require 'rails_helper'

describe 'quota/edit' do
  before :each do
    @quotum = FactoryGirl.create(:quotum, name: "RSpec edit Quotum")
  end


  it 'View: display quota edit html page correctly' do

    render

    expect(rendered).to render_template(partial: "_form")
    expect(rendered).to include("#{@quotum.name}")
    expect(rendered).to include('Name')
    #expect(rendered).to include("Editing #{@quotum.name}")
  end

  it 'View: display quota edit js page correctly', js: true do

    render

    expect(rendered).to render_template(partial: "_form")
    expect(rendered).to include("#{@quotum.name}")
    expect(rendered).to include('Name')
    #expect(rendered).to include("Editing #{@quotum.name}")
  end
end



