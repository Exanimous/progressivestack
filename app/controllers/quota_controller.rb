class QuotaController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :set_quota, only: [:index]
  before_action :set_quotum, only: [:show, :edit, :update, :destroy]

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
      if @quotum.save
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
      if @quotum.save
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
    @quotum = Quotum.find(params[:id])
  end

  def set_quota
    @quota = Quotum.all
  end

  def quotum_params
    params.require(:quotum).permit(:name, :_destroy)
  end
end
