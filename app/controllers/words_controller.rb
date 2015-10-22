class WordsController < ApplicationController
  before_action :admin_user,     only: [:create, :destroy]
  
  def index
    @filterrific = initialize_filterrific(
      Word,
      params[:filterrific],
      select_options: {
        with_category_id: Category.options_for_select
      }
    ) or return
    @words = @filterrific.find.page params[:page]
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data Word.all.to_csv }
    end
  end

  def show
    @word = Word.find params[:id]
    @answers = @word.answers
    @user_word = current_user.user_words.build 
  end
end
