class StaticController < ApplicationController

  def home
    if current_user
      sign_out current_user
    end
  end

  def como_funciona
  end

  def que_es
  end

  def testimonios
  end

  def contacto
  end

  def coming_soon
    render layout: "blank"
  end

  def mail
    render layout: "blank_two"
  end

end
