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
        @transaction.update(status: true)
        donation_check @transaction
        request_check @transaction
        redirect_to '/my_dashboard', notice: "Transactions succesfully cofirmed"
    else
        redirect_to '/my_dashboard', notice: "you don't have permission to acces this transaction"
    end

  end

  def donation_check (transaction)
    @donation = Donation.find(transaction.donation_id)
    if @donation.transactions.all? {|transc| transc.status == true}
      @donation.update(completed: true)
      UserWorker.perform_in(10.seconds,  @donation.id)
    end
    @donation
  end

  def request_check (transaction)
    @request = Request.find(transaction.request_id)
    if @request.transactions.all? {|transc| transc.status == true}
      @request.update(completed: true)
    end
  end

  def show
    @transaction = Transaction.find(params[:id])
    render layout: "admin_dashboard_layout"
  end


private
  def invoice_params
    params.permit(:invoice)
  end
end
