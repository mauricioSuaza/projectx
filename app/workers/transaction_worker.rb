class TransactionWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 10


	sidekiq_retry_in do |count|
    rand(300) * (count + 1) # (i.e. 10, 20, 30, 40, 50)
  end

	def perform(transaction_id)
    @transaction = Transaction.find(transaction_id)
    if @transaction.status == false
      @transaction.donation.user.update(blocked: true)
      byebug
      @user = User.find(@transaction.receiver_id)
      @user.update(saldo: @user.saldo + @transaction.value)
      
      #create notificacion fallida.
    end
  end
  
end