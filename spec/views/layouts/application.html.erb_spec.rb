# spec/views/layouts/application.html.erb_spec.rb
require 'rails_helper'

describe 'layouts/application.html.erb' do

  # include required application helper methods
  before do
    controller.singleton_class.class_eval do
      protected
      def current_or_guest_user(create = false)
        false
      end

      helper_method :current_or_guest_user
    end
  end


  it 'View: application display header' do

    render

    expect(rendered).to render_template(partial: "_header")
  end

  it 'View: application display footer' do

    render

    expect(rendered).to render_template(partial: "_footer")
  end

  it 'View: application debug messages' do

    render

    expect(rendered).to render_template(partial: "_debug")
  end

  it 'View: application flash messages' do

    render

    expect(rendered).to render_template(partial: "_flash_messages")
  end

  it 'View: application dialog' do

    render

    expect(rendered).to render_template(partial: "_dialog")
  end
end