class ChatsController < ApplicationController

  before_action :set_chat, only: [:destroy]

  before_action :is_support, only: [:admin_index]
  
  def is_support
    unless current_user.has_role? :support 
      redirect_to '/'
      flash[:notice] = "No tienes permiso para acceder a esta sección."
    end
  end

  def index
    @users = User.all
    @chats = Chat.search(params[:search]).paginate(page: params[:page], per_page: 30)
    @admin = User.where(admin: true)
    if current_user.admin?
      render layout: "chats_dashboard_layout"
    else
      render layout: "dashboard_layout" 
    end
  end

  def admin_index
    @users = User.all
    @chats = Chat.search(params[:search]).paginate(page: params[:page], per_page: 30)
    @admin = User.where(admin: true)
    #@notifications_count = @current_user.notifications.where("message_id IS NOT NULL").where(read: false).count
    render layout: "chats_dashboard_layout"
  end

  def create
    if Chat.between(params[:sender_id],params[:recipient_id]).present?
      @chat = Chat.between(params[:sender_id], params[:recipient_id]).first
    else
      @chat = Chat.create!(chat_parms)
    end
    if current_user.admin
      redirect_to support_chat_path(@chat)
    else
      redirect_to chat_messages_path(@chat)
    end
  end


  def destroy
    @chat.destroy
    respond_to do |format|
      format.html { redirect_to chats_url, notice: 'Chat was destroyed.' }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_parms
    params.permit(:sender_id, :recipient_id)
  end
end
