App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function(data) {
    $("#messages").removeClass('hidden');
    messages = $('#messages');
    chat_room_id = messages.data('chat-room-id');
    if (data.chatroom_id == chat_room_id) {
      return $('#messages').append(this.renderMessage(data));
    };
	},

  renderMessage: function(data) {
  	if (data.text!==undefined) {
  		swal('Recuerde que solo puede enviar un mensaje hasta que el equipo de soporte se comunique con usted.');
  	}else{
      if (data.current_is_sender === true) {
        return "<div class='ui segment' style='display: flex; flex-direction: column;'>"
                + "<div class='item align' style='padding: 20px'>"
                  + "<div class='content'>"
                    + "<div class='header'><strong>" + data.user + "</strong></div>"
                      + "<div class='list'>"
                        + "<div class='item item-chat-cont' style='padding: 20px;'>"
                          + data.message
                            + "<div style='font-size: 9px; font-weight: 500; float: right; margin: 15px 0px 0px 5px;'>"
                              + data.time
                            +
                            "</div> </div>  </div>  </div>  </div> </div>" ;
      }
      else{
        return   "<div class='ui segment' style='display: flex; flex-direction: column;'>"
                  + "<div class='item aligntwo' style='padding: 20px'>"
                  + "<div class='content'>"
                    + "<div class='header'><strong>" + data.user + "</strong></div>"
                      + "<div class='list'>"
                        + "<div class='item item-chat-contwo' style='padding: 20px;'>"
                          + data.message
                            + "<div style='font-size: 9px; font-weight: 500; float: right; margin: 15px 0px 0px 5px;'>"
                              + data.time
                            +
                            "</div> </div>  </div>  </div>  </div> </div>" ;
      }
  	}
  }
});
