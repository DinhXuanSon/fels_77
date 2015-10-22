class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    if params[:option].nil?
      respond_to do |format|
        format.csv { send_data Relationship.all.to_csv }
      end
    else 
      send params[:option]
    end
  end

  def create
    @user = User.find params[:followed_id]
    current_user.follow @user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  private 
   ["following", "followers"].each do |method_name|
     define_method method_name do
       @title = t "#{method_name}"
       @user  = User.find_by(id: params[:user_id]) || User.find_by(slug: params[:user_id])
       @users = @user.send(method_name).paginate page: params[:page]
       render 'index'
     end
   end
end
