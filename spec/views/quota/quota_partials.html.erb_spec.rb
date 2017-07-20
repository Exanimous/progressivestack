# spec/views/quota/quota_partials.html.erb_spec.rb
require 'rails_helper'

describe 'quota/index.html.erb' do
  before :each do
    @access_control = AccessControl.new(nil)
  end

  it 'View: quota index display index partial' do

    @quota = @access_control
    render

    expect(rendered).to render_template(partial: "_index")
    expect(rendered).to include('Quota')
  end

  it 'View: quota index display quota partial' do

    @quota = @access_control
    render

    expect(rendered).to render_template(partial: "quota/partials/_quota", locals: { access_control: @quota })
  end
end
