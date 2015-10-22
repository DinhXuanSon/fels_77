class LessonsController < ApplicationController
  before_action :logged_in_user

  def index
    respond_to do |format|
      format.csv { send_data Lesson.all.to_csv }
    end
  end

  def show
    @lesson = Lesson.find params[:id]
  end
    
  def create
    @lesson = current_user.lessons.create params_lesson
    if @lesson
      redirect_to [@lesson.category, @lesson]
    else
      flash[:danger] = t "flashs.invalid"
      redirect_to categories_url
    end
  end
  def update
    @lesson = Lesson.find params[:id]
    if @lesson.update_attributes params_lesson
      redirect_to result_path @lesson
    else
      flash[:danger] = t "flashs.invalid"
      redirect_to root_url
    end
  end


  private
  def params_lesson
    params.require(:lesson).permit :category_id, word_lessons_attributes: [:id, :answer_id]
  end
end
