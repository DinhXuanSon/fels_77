class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.paginate page: params[:page]
    respond_to do |format|
      format.html
      format.csv { send_data User.all.to_csv }
    end
  end

  def show
    @user = User.find params[:id] 
    @lessons = Lesson.filter_lesson(@user.id)
                      .paginate(page: params[:page])
                      .order created_at: :DESC
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params 
    if @user.save
      log_in @user
      flash[:success] = t :welcome
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id] 
    if @user.update_attributes user_params 
      flash[:success] = t :profile_updated
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t :user_deleted
    redirect_to users_url
  end
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find params[:id] 
      redirect_to root_url unless current_user? @user
    end
end
