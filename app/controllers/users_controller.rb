class UsersController < ApplicationController
	load_and_authorize_resource

	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:notice] = "Successfully created User."
			redirect_to users_path
		else
			render :action => 'new'
		end
	end

	def edit
		if current_user.admin?
			@user = User.find(params[:id])
		else
			@user = current_user
		end
	end

	def update
		if current_user.admin?
			@user = User.find(params[:id])
		else
			@user = current_user
		end
		params[:user].delete(:password) if params[:user][:password].blank?
		params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
		if @user.update_attributes(params[:user])
			flash[:notice] = "Successfully updated User."
			redirect_to users_path
		else
			render :action => 'edit'
		end
	end

	def destroy
		@user = User.find(params[:id])
		if @user.destroy
			flash[:notice] = "Successfully deleted User."
			redirect_to users_path
		end
	end

end
