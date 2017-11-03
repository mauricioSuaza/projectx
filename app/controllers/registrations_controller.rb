class RegistrationsController < Devise::RegistrationsController

  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.
    
  layout "dashboard_layout.html", only: [:edit, :update]

  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def create
    super do
    	refferal_email = params[:user][:refferal]
    	root = User.find_by_email(refferal_email)
      if refferal_email
        @user.update(referral_email: refferal_email)
    		if !root.nil?
          @user.update(parent_id: root.id)
    		end
    	end
    end
  end
  
  def edit
    if current_user.has_role? :admin
      @user_admin = User.find(params[:format])
      render layout: "admin_dashboard_layout"
    elsif current_user.blocked?
      redirect_to chats_path
      flash[:notice] = "Su cuenta a sido bloqueada, contacte al equipo de soporte."
    else
      super
    end
  end

  def update
    if current_user.has_role? :admin
      user = User.find(params[:user][:id])
      referral = User.find_by(email: params[:user][:referral_email])
      if user.update(saldo: params[:user][:saldo], 
                    referral_email: params[:user][:referral_email],
                    name: params[:user][:name], parent_id: referral.id)
        redirect_to '/users_admin'
        flash[:notice] = "Usuario actualizado exitosamente."
      else
        flash[:notice] = "No se pudo actulizar el usuario, vuelva a intentarlo."
      end
    else
      super
    end
  end

  protected
    def after_update_path_for(resource)
      if resource.has_role? :user
        '/my_dashboard'
      elsif current_user.has_role? :admin
        '/users_admin'
      else
        '/'
      end
    end
  
    def after_sign_up_path_for(resource)
      '/' # Or :prefix_to_your_route
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:saldo])
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
      params.require(:user).permit(:name, :btc, :referral_email, :phone, :country, :email,
                                   :password, :password_confirmation, :current_password, :saldo)
    end
end