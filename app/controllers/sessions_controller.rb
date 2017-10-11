class SessionsController < Devise::SessionsController
  prepend_before_action :captcha_valid, only: [:create]
  

  private
    def captcha_valid
      unless verify_recaptcha
        self.resource = resource_class.new(sign_in_params)
        resource.validate # Look for any other validation errors besides Recaptcha
        respond_with_navigational(resource) { 
          redirect_to new_user_session_url
          flash[:notice] = "Complete el captcha" }
      end 
    end
end