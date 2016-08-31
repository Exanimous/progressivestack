# spec/views/quota/quota_partials.html.erb_spec.rb
require 'rails_helper'

describe 'quota/index.html.erb' do
  it 'View: quota index display index partial' do

    @quota = Quotum.all
    render

    expect(rendered).to render_template(partial: "_index")
    expect(rendered).to include('Quota')
  end

  it 'View: quota index display quota partial' do

    @quota = Quotum.all
    render

    expect(rendered).to render_template(partial: "quota/partials/_quota", locals: { quota: @quota })
  end
end
