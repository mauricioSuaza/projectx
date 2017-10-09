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

    if current_user.admin?
      render layout: "chats_dashboard_layout"
    else
      render layout: "dashboard_layout" 
    end
  end


  def admin_index
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
    render layout: "chats_dashboard_layout"
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
        elsif @messages_count > 2 && !Chat.find(@chat.id).messages.last.user.admin?
          redirect_to chat_messages_path(@chat.id)
          flash[:notice] = "You can't send another message until an admin reply you back. Thank you for your patience"
        else
          @message.save
          create_notification(@message)
          #passing broadcast messages_chanel
          action_cable(@message)
        end
      else
        @message.save
        create_notification(@message)
        #passing broadcast messages_chanel
        action_cable(@message)
      end
    else
      if @message.save
        create_notification(@message)
        #passing broadcast messages_chanel
        action_cable(@message)
      end
    end
  end

  def create_notification(data)
    @receiver = User.find(data.chat.recipient_id)
    @sender = User.find(data.chat.sender_id)
    if !data.nil?
      if data.user_id == data.chat.recipient_id
        @sender = @sender.notifications.create(owner_id: data.user_id, read: false, 
                                      message_id: data.id)
      elsif
        @receiver.notifications.create(owner_id: data.user_id, read: false, 
                                      message_id: data.id)
      end
    end
  end

  def action_cable message
    ActionCable.server.broadcast 'messages',
      message: message.body,
      user: message.user.name,
      time: message.created_at.strftime("%m/%d/%y  %H:%M:%S"),
      admin: @chat.sender.admin? || @chat.recipient.admin? ,
      current_user_admin: current_user.admin?,
      count: @chat.messages.count,
      current_is_sender: current_user.id == @chat.sender_id
  end

private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
