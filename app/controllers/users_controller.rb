require 'pry'

class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index]
  before_action :correct_user, only: [:edit, :update]

  def index 
    @users = User.all
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

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end


    #Before Filters

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