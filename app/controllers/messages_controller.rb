class MessagesController < ApplicationController

  before_action do
    @chat = Chat.find(params[:chat_id])
  end

  def index
    #prevents anyone to access the chat
    if protect_chat(@chat) === false 
      #contains the id of the chat
      @chatroom = @chat
      @messages = @chat.messages.order("created_at ASC")

      #Mark last message as readed
      mark_message_as_readed(@messages.last, @chatroom)

      @message = @chat.messages.new
      #@notifications_count = @current_user.notifications.where("message_id IS NOT NULL").where(read: false).count
      if current_user.admin?
        render layout: "chats_dashboard_layout"
      else
        render layout: "dashboard_layout" 
      end
    else
      redirect_to root_path
      flash[:notice] = "No autorizado"
    end
  end

  def mark_message_as_readed(message, chatroom)
    unless message.nil?
      if current_user.id == chatroom.sender_id
        message.sender_readed = true
      else
        message.receiver_readed = true
      end
      message.save(validate: false)
    end
  end

  def add_invoice
    invoice = @chat.messages.new(invoice: params[:invoice], body: nil, user_id: current_user.id)
    invoice.save(validate: false)
    redirect_to chat_messages_path(@chat) 
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

    #contains the id of the chat
    @chatroom = @chat
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
          redirect_to chat_messages_path(@chat)
        end
      else
        @message.save
        create_notification(@message)
        #passing broadcast messages_chanel
        action_cable(@message)
        redirect_to chat_messages_path(@chat)
      end
    else
      if @message.save
        create_notification(@message)
        #passing broadcast messages_chanel
        action_cable(@message)
        redirect_to chat_messages_path(@chat)
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
      chatroom_id: message.chat_id,
      current_user_admin: current_user.admin?,
      count: @chat.messages.count,
      current_is_sender: current_user.id == @chat.sender_id
  end

  def protect_chat chat
    unless current_user.id == chat.sender_id or current_user.id == chat.recipient_id
      return true
    else
      return false
    end
  end

private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
