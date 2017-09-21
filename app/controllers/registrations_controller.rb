class RegistrationsController < Devise::RegistrationsController
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
  
  protected
  
    def after_sign_up_path_for(resource)
      '/' # Or :prefix_to_your_route
    end

  private
    def sign_up_params
      params.require(:user).permit(:name, :btc, :phone, :country, :email, :password, :password_confirmation, :refferal)
    end

    
    def account_update_params
      params.require(:user).permit(:name, :btc, :phone, :country, :email, :password, :password_confirmation, :current_password)
    end
end