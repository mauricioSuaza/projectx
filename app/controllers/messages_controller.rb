class MessagesController < ApplicationController
  
  before_action do
    @chat = Chat.find(params[:chat_id])
  end

  def index
    @messages = @chat.messages
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end
    if params[:m]
      @over_ten = false
      @messages = @chat.messages
    end
    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.read = true;
      end
    end
    @message = @chat.messages.new
    render layout: "dashboard_layout"
  end

  def new
    @message = @chat.messages.new
  end

  def create
    #boolean if the conversation is being with an admin
    @admin = @chat.sender.admin? || @chat.recipient.admin? 
    #boolean if the current_user is admin
    @current_user_admin = current_user.admin?
    #contains the amount of messages on conversation
    @messages_count = @chat.messages.count

    @message = @chat.messages.new(message_params)
    if @admin == true
      if @current_user_admin == false
        if @messages_count == 1
          redirect_to chat_messages_path(@chat.id)
          flash[:notice] = "You can't send another message until an admin reply you back. Thank you for your patience"
        else
          @message.save
          #passing broadcast messages_chanel
          ActionCable.server.broadcast 'messages',
            message: @message.body,
            user: @message.user.email,
            time: @message.created_at.strftime("%m/%d/%y  %H:%M:%S"),
            admin: @chat.sender.admin? || @chat.recipient.admin? ,
            current_user_admin: current_user.admin?,
            count: @chat.messages.count
        end
      else
        @message.save
        #passing broadcast messages_chanel
        ActionCable.server.broadcast 'messages',
          message: @message.body,
          user: @message.user.email,
          time: @message.created_at.strftime("%m/%d/%y  %H:%M:%S"),
          admin: @chat.sender.admin? || @chat.recipient.admin? ,
          current_user_admin: current_user.admin?,
          count: @chat.messages.count
      end
    else
      if @message.save
        #passing broadcast messages_chanel
        ActionCable.server.broadcast 'messages',
          message: @message.body,
          user: @message.user.email,
          time: @message.created_at.strftime("%m/%d/%y  %H:%M:%S"),
          admin: @chat.sender.admin? || @chat.recipient.admin? ,
          current_user_admin: current_user.admin?,
          count: @chat.messages.count
      end
    end
  end

private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end