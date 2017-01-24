class QuotaController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :set_quota, only: [:index]
  before_action :set_quotum, only: [:show, :edit, :update, :destroy]

  before_action -> { current_or_guest_user(true) }, only: [:create, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  after_action :force_csrf_headers, only: [:create, :update, :destroy]

  # /* A note on parameters & historyState API

    # parameters are assigned in JS to control popstate behaviour of the history API
    # ?fragment=true tells us to only render a partial rather than index action

  # */

  # index action with ajax support
  # 1: handle 5 possible states: (xhr & fragment) (xhr & redirect) (xhr index) (fragment) (index)
  def index
    respond_to do |format|
      format.html {
        if request.xhr?
          if params[:fragment].present?
            return render partial: 'quota/partials/quota', locals: { quota: @quota } ,layout: false
          else
            render :index
          end
        else
          if params[:fragment].present?
            render partial: 'quota/partials/quota', locals: { quota: @quota } ,layout: false
          else
            render :index
          end
        end
      }
    end
  end

  def new
    @quotum = Quotum.new
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.js {
        render :edit
      }
      format.html {
        render :edit
      }
    end
  end

  def create
    @quotum = Quotum.new(quotum_params)

    respond_to do |format|
      if verify_recaptcha(model: @quotum) && @quotum.save
        flash.now[:success] = "Quotum: #{@quotum.name} was successfully created."
        format.html
        format.js
      else
        flash.now[:error] = "There is a problem.  Your data has #{ pluralize(@quotum.errors.count, "error")}"
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  def update
    @quotum.assign_attributes(quotum_params)

    respond_to do |format|
      if verify_recaptcha(model: @quotum) && @quotum.save
        flash.now[:success] = "Quotum: #{@quotum.name} was successfully updated."
        format.html
        format.js
      else
        flash.now[:error] = "There is a problem.  Your data has #{ pluralize(@quotum.errors.count, "error")}"
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  def destroy
    if @quotum.destroy
      flash.now[:notice] = "Quotum deleted."
    else
      respond_to do |format|
        flash.now[:error] = "Quotum: #{@quotum.name} could not be deleted."
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  private

  def set_quotum
    @quotum = Quotum.find_by_slug!(params[:slug])
  end

  def set_quota
    @quota = Quotum.visible.all
  end

  def quotum_params
    params.require(:quotum).permit(:name, :_destroy)
  end

  protected

  # support ajax authentication actions by manually appending CSRF data to header
  def force_csrf_headers
    if request.xhr? and guest_signed_in?
      # Add csrf tokens directly to response headers
      response.headers['X-CSRF-Token'] = "#{form_authenticity_token}"
      response.headers['X-CSRF-Param'] = "#{request_forgery_protection_token}"
    end
  end
end
