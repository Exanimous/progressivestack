# spec/views/quota/new.html.erb_spec.rb
require 'rails_helper'

describe 'quota/new' do
  it 'View: display quota new html page correctly' do

    @quotum = Quotum.new
    render

    expect(rendered).to render_template(partial: "_form")
    expect(rendered).to include('Name')
    expect(rendered).to include('New Quotum')
  end

  it 'View: display quota new js page correctly', js: true do

    @quotum = Quotum.new
    render

    expect(rendered).to render_template(partial: "_form")
    expect(rendered).to include('Name')
    expect(rendered).to include('New Quotum')
  end
end



