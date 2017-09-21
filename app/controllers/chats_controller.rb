class ChatsController < ApplicationController

  before_action :set_chat, only: [:destroy]

  def index
    @users = User.all
    @chats = Chat.all
    @admin = User.where(admin: true)
  end

  def create
    if Chat.between(params[:sender_id],params[:recipient_id]).present?
      @chat = Chat.between(params[:sender_id], params[:recipient_id]).first
    else
      @chat = Chat.create!(chat_parms)
    end
    redirect_to chat_messages_path(@chat)
  end


  def destroy
    @chat.destroy
    respond_to do |format|
      format.html { redirect_to chats_url, notice: 'Conversacion fue eliminada' }
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
