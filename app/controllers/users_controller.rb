require 'pry'

class UsersController < ApplicationController

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
   	    redirect_to @user
  	else
  		render 'new'
  	end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end
end