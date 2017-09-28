class UserWorker
	include Sidekiq::Worker
	sidekiq_options retry: true

	def perform(transaction_id)
		#user = User.find(user_id)
    #user.update_attributes(name: 'testing 2')
    @transaction = Transaction.find(transaction_id)
    @transaction.update(status: true)
    @sender = User.find(@transaction.sender_id)
    @sender.update(saldo:  (@sender.saldo + (@transaction.value + (@transaction.value*0.3))))    
	end
end