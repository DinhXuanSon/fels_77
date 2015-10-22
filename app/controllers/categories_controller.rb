class CategoriesController < ApplicationController
  before_action :logged_in_user

  def index
    @categories = Category.paginate page: params[:page]
    respond_to do |format|
      format.html
      format.csv { send_data Category.all.to_csv }
    end
  end

  def show
    @category = Category.find params[:id]
    @words = @category.words.paginate page: params[:page]
    @learwords = Word.learn_category(current_user,@category)

  end
end
