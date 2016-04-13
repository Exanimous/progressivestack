# spec/views/layouts/application.html.erb_spec.rb
require 'rails_helper'

describe 'layouts/application.html.erb' do
  it 'View: application display header' do

    render

    expect(rendered).to render_template(partial: "_header")
  end

  it 'View: application display footer' do

    render

    expect(rendered).to render_template(partial: "_footer")
  end

  it 'View: application display messages' do

    render

    expect(rendered).to render_template(partial: "_messages")
  end

  it 'View: application debug messages' do

    render

    expect(rendered).to render_template(partial: "_debug")
  end
end