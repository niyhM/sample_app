require 'pry'

class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index 
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new()

  	#---------------------------------------------------------------#
  	if Rails.env == 'development'
  		@user.email = "#{('a'..'g').to_a.shuffle.join}" +
  					  "#{(0..9).to_a.shuffle[0..2].join}@gmail.com"
  		@user.name = "#{('a'..'z').to_a.shuffle[0..7].join}"
  	end
  	#---------------------------------------------------------------#
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		flash[:success] = "Welcome to the Sample App!"
        log_in @user
   	    redirect_to @user
  	else
  		render 'new'
  	end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  def edit
  end

  def destroy
    #because only admins can destroy other users accounts:
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end


    #Before Filters


    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    #confirms a logged-in user
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end