class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: 'Benutzer erfolgreich angelegt.'
    else
      render :new  #
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'Benutzer erfolgreich aktualisiert.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'Benutzer erfolgreich gelöscht.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :role) # E-Mail, Passwort und Rolle aktualisieren
  end
end
