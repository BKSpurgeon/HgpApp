class UsersController < Devise::RegistrationsController
  respond_to :html, :json
# require 'google/api_client'
# require 'google/api_client/client_secrets'


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
  flash[:notice] = "User was successfully created." if @user.save
  respond_with(@user)
  # def create
  #   @user = User.new(params)
  #    respond_to do |format|
  #     if @user.save
  #       format.html do#{ render html: }
  #       #format.json { render json: @user.to_json }
  #          redirect_to
  #         edit_user_path(current_user)
  #        end
  #        format.json { render json: @user.to_json }
  #        notice: "%{@user] was Successfully created! Now select or create a new cohort."
  #     else
  #       render 'new'
  #       # format.html { render :new }
  #       # format.json { render json: @user.errors, status:
  #       #   :unprocessable_entity }
  #      end
  #   end
  end

  def edit
    @user = User.find(params[:user_id])
    @cohort = @user.build_cohort
  end


  def show
    @user = User.find(params[:user_id])
    @cohort = @user.cohort
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
  end

  def index
     @users = User.cohort.where(params[:cohort_id])
     #@users = User.find(params[:cohort_id])
     # @hash = Gmaps4rails.build_markers(@users) do |user, marker|
     #    marker.lat user.latitude
     #    marker.lng user.longitude
     #    marker.title user.title
     # end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update!(user_params)
        @cohort = @user.cohort
        format.html { redirect_to @cohort,
        notice: "User updated!"}
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status:
          :unprocessable_entity}
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to root_path
    end
  end



 private

 def create_login
    email = self.email.split(/@/)
    login_taken = User.where(login: email[0]).first
    self.login =
    if login_taken
      self.email
    else
      email[0]
    end
  end

  def user_params
    params.require(:user).permit(:avatar, :cohort_id, :city, :username, :first_name, :last_name, :genius, :email, :password, :avatar, :email2, project_attributes: [:app_name, :user_id, :coding, :github, :url, :project_details, :start_date])
  end

  def project_params
    params.require(:project).permit(:authenticity_token, :github, :locale)
  end

  def self.find_for_database_authentication conditions
      where(login: conditions[:email]).first || where(email: conditions[:email]).first
  end

   def authenticate_user!
      unless current_user
         flash[:alert] = "Unauthorized Access: Genius, try again!"
         redirect_to root_path
       end
    end
end
