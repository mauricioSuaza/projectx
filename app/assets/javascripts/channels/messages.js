App.messages = App.cable.subscriptions.create('MessagesChannel', {  
  received: function(data) {
    $("#messages").removeClass('hidden');
		return $('#messages').append(this.renderMessage(data));
	},
	
  renderMessage: function(data) {
  	if (data.text!==undefined) {
  		swal('Recuerde que solo puede enviar un mensaje hasta que el equipo de soporte se comunique con usted.');
  	}else{
    	return "<strong>" + data.user + "</strong>" + " " + data.time + "<br>" + data.message + "<br>" ;
  	}
  }
});
