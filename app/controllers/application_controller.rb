class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)

    if resource.has_role? :user
      '/my_dashboard'
    elsif resource.has_role? :admin
      '/admin_dashboard'
    elsif resource.has_role? :support
      '/admin_chats'
    else
      '/my_dashboard'
    end

  end

  def after_sign_out_path_for(resource)
    '/'
  end
end
