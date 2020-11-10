class ApisController < ApplicationController
  before_action :set_category

  def index
    @ideas = Idea.all
    render json: { status: 'error', code: '404' } if @ideas.blank?
  end

  def show
    if @category.present?
      @ideas = Idea.where(category: @category)
    else
      render json: { status: 'error', code: '404' }
    end
  end

  def create
    Idea.transaction do
      if @category.present?
        Idea.create!(category: @category, body: params[:body])
      else
        Idea.create!(category: Category.create!(name: params[:category_name]), body: params[:body])
      end
    end
    render json: { status: 'success', code: '201' }
  rescue StandardError
    render json: { status: 'error', code: '422' }
  end

  def set_category
    @category = Category.find_by(name: params[:category_name])
  end
end
