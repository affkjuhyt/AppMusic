class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :edit_params,     only: [:edit, :update, :destroy]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @subscriptions = @user.get_up_voted Community
    @playlists = @user.playlists.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = "Welcome to SoundIt!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_back fallback_location: @user
    else
      render 'edit'
    end
  end

  def destroy
    if User.all.length != 1
      @user = User.find(params[:id])

      if @user.admin? && User.all.where(admin: 't').length == 1
        redirect_back fallback_location: root_url, alert: "Cannot remove only admin!"
      else
        @user.destroy
        redirect_back fallback_location: root_url, alert: "Successfully Removed User!"
      end

    else 
      redirect_back fallback_location: root_url, alert: "Cannot remove only User!"
    end
  end

  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
  end

  def add_admin
    @user = User.find(params[:id])
    attributes = user_params.clone
    attributes[:admin] = "t"
    @user.update_attributes(attributes)

    redirect_to admin_mgmt_path, alert: "Successfully created admin."
  end

  def spotify
    redirect_back fallback_location: root_url, alert: "Sign in Successul"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)

    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def edit_params
      @user = User.find(params[:id]) 
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    end
end
