class UserWordsController < ApplicationController
  def create
    @user_word = current_user.user_words.build user_word_params
    if @user_word.save
      flash[:success] = t :has_learn_words
      redirect_to words_path
    else
      flash[:unsuccess] = t :hasnt_learn_words
      redirect_to words_path
    end
  end

  def destroy
    @user_word.destroy
    flash[:success] = t :unlearned
    redirect_to words_path
  end
  def index
    respond_to do |format|
      format.html
      format.csv { send_data UserWord.all.to_csv }
    end
  end

  private
  def user_word_params
    params.require(:user_word).permit :word_id
  end
end
