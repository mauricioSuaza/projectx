module ChatsHelper
	def set_bold_if_not_readed chat
    if current_user.id == chat.sender_id
		  if chat.messages.last.sender_readed
		   	bold= "normal"
		  elsif chat.messages.last.sender_readed == false
		  	bold= "bold"
		  end
		elsif current_user.id == chat.recipient_id
		  if chat.messages.last.receiver_readed
		    bold= "normal"
		  elsif chat.messages.last.receiver_readed == false
		 		bold= "bold"
		  end
		end
  end

  def gets_name_current_user_chatting chat
  	if chat.sender_id == current_user.id
  		recipient = User.find(chat.recipient_id)
  	else
  		recipient = User.find(chat.sender_id)
  	end
  	recipient.email.html_safe
  end
end


