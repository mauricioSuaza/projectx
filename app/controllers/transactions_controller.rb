class TransactionsController < ApplicationController
    
    def add_invoice
        @transaction = Transaction.find(params[:transaction_id])
        @transaction.invoice = params[:invoice]
        @transaction.save!
        redirect_to '/my_dashboard', notice: "image succesfully saved"
    end

    def confirm_transaction
        @transaction = Transaction.find(params[:transaction_id])
        
        if @transaction.receiver_id == current_user.id
            #@transaction.update(status: true)
            #@sender = User.find(@transaction.sender_id)
            #@sender.update(saldo:  (@sender.saldo + (@transaction.value + (@transaction.value*0.3))))
            #redirect_to '/my_dashboard', notice: "transaction sucesfully confirmed"
            UserWorker.perform_in(1.minutes, @transaction.id)
            flash[:notice] = "Transaction sucesfully confirmed!. Your total balance will be updated 
                in 15 days, thank you for trusting in us."
            redirect_to '/my_dashboard'
            
        else
            redirect_to '/my_dashboard', notice: "you don't have permission to acces this transaction"
        end
       
    end

private
    def invoice_params
      params.permit(:invoice)
    end

end
