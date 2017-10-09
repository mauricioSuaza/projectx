class RegistrationsController < Devise::RegistrationsController

  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.
    
  layout "dashboard_layout.html", only: [:edit]
  
  def create
    super do
    	refferal_email = params[:user][:refferal]
    	root = User.find_by_email(refferal_email)
    	if refferal_email
    		if !root.nil?
    			@user.parent_id = root.id
    		end
    	end
    end
  end
  
  def edit
    if current_user.blocked?
      redirect_to chats_path
      flash[:notice] = "Su cuenta a sido bloqueada, contacte al equipo de soporte."
    else
      super
    end
  end
  protected
  
    def after_sign_up_path_for(resource)
      '/' # Or :prefix_to_your_route
    end

  private
    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_up_params
        resource.validate # Look for any other validation errors besides Recaptcha
        respond_with_navigational(resource) { 
          render :new
          flash[:notice] = "Complete el captcha" }
      end 
    end
    def sign_up_params
      params.require(:user).permit(:name, :btc, :phone, :country, :email, :password, :password_confirmation, :refferal)
    end

    
    def account_update_params
      params.require(:user).permit(:name, :btc, :phone, :country, :email, :password, :password_confirmation, :current_password)
    end
end