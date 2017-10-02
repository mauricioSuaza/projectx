class SessionsController < Devise::SessionsController
  def create
    if (User.where(email: params[:user][:email]).first.blocked?)
      redirect_to contacto_path
      flash[:notice] = "Your Account has been blocked, get in touch with the support team."
    else
      super
    end
  end
end