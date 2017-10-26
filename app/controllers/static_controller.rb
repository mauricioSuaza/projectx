class StaticController < ApplicationController

  def home
=begin
    if current_user
      sign_out current_user
    end
=end
  end

  def como_funciona
  end

  def que_es
  end

  def testimonios
  end

  def panel_donacion
    render layout: "dashboard_layout"
  end

  def faq
    render layout: "dashboard_layout"
  end

  def contacto
    @contact_message = ContactMessage.new
  end

  def coming_soon
    render layout: "blank"
  end

  def mail
    render layout: "blank_two"
  end

  def terminos
  end

end
